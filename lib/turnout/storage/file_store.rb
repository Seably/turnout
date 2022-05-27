require 'yaml'
require 'fileutils'

module Turnout
  module Storage
    class FileStore < SettingsStore
      attr_reader :path

      def initialize
        @path = self.class.default_path
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

      def self.default_path
        named_paths.values.first
      end

      private

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
