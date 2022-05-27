require 'yaml'

module Turnout
  module Storage
    class RedisStore < SettingsStore
      attr_accessor :redis

      def initialize
        @redis = ::Redis.new(url: ENV["REDIS_URL"])
        super
        import_yaml if exists?
      end

      def exists?
        redis.exists(Turnout.config.redis_key).positive?
      end

      def write
        redis.set(Turnout.config.redis_key, to_yaml)
      end

      def delete
        redis.del(Turnout.config.redis_key)
      end

      private

      def import_yaml
        import YAML::load(redis.get(Turnout.config.redis_key)) || {}
      end
    end
  end
end
