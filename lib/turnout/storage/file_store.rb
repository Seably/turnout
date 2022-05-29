require 'yaml'
require 'fileutils'

module Turnout
  module Storage
    class FileStore < SettingsStore
      attr_reader :path

      def initialize
        super()
        @path = negotiate_path
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

      def self.default_path
        named_paths.values.first
      end

      private

      def negotiate_path
        return self.class.default_path unless task

        path_name = (task.name.split(':') - ['maintenance', 'start', 'end']).join(':')
        return self.class.default_path if path_name == ''

        self.class.named_paths[path_name.to_sym]
      end

      def dir_path
        File.dirname(path)
      end

      def import_yaml
        import YAML::load(File.open(path)) || {}
      end

      def self.named_paths
        Turnout.config.named_maintenance_file_paths
      end
    end
  end
end
