require 'yaml'
require 'fileutils'

module Turnout
  module Storage
    class RedisStore < SettingsStore
      REDIS_KEY = ENV["TURNOUT_REDIS_KEY"] || "TURNOUT_MAINTENANCE".freeze
      attr_accessor :redis

      def initialize
        @redis = ::Redis.new(url: ENV["REDIS_URL"])
        super
        import_yaml if exists?
      end

      def exists?
        redis.exists(REDIS_KEY).positive?
      end

      def write
        redis.set(REDIS_KEY, to_yaml)
      end

      def delete
        redis.del(REDIS_KEY)
      end

      # Find the first MaintenanceFile that exists
      def self.find
        redis = Redis.new(url: ENV["REDIS_URL"])
        redis.get(REDIS_KEY)
      end

      def self.named(name)
        path = named_paths[name.to_sym]
        self.new(path) unless path.nil?
      end

      def self.default
        find
      end

      private

      def import_yaml
        import YAML::load(redis.get(REDIS_KEY)) || {}
      end
    end
  end
end
