require 'yaml'
require 'fileutils'

module Turnout
  class MaintenanceFile < SettingsStore
    attr_reader :path

    def initialize(path)
      @path = path
      super()
      import_yaml if exists?
    end

    def exists?
      File.exist? path
    end

    def to_h
      SETTINGS.each_with_object({}) do |att, hash|
        hash[att] = send(att)
      end
    end

    def to_yaml(key_mapper = :to_s)
      to_h.each_with_object({}) { |(key, val), hash|
        hash[key.send(key_mapper)] = val
      }.to_yaml
    end

    def write
      FileUtils.mkdir_p(dir_path) unless Dir.exist? dir_path

      File.open(path, 'w') do |file|
        file.write to_yaml
      end
    end

    def delete
      File.delete(path) if exists?
    end

    # Find the first MaintenanceFile that exists
    def self.find
      path = named_paths.values.find { |p| File.exist? p }
      self.new(path) if path
    end

    def self.named(name)
      path = named_paths[name.to_sym]
      self.new(path) unless path.nil?
    end

    def self.default
      self.new(named_paths.values.first)
    end

    private

    def dir_path
      File.dirname(path)
    end

    def import_yaml
      import YAML::load(File.open(path)) || {}
    end
  end
end
