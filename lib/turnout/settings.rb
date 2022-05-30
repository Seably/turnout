module Turnout
  class Settings
    require 'turnout/storage/settings_store'
    require 'turnout/storage/redis_store'
    require 'turnout/storage/file_store'
    require 'turnout/storage/env_store'

    def self.storage
      case Turnout.config.settings_store
      when :redis
        Storage::RedisStore.new
      when :env
        Storage::EnvStore.new
      else
        Storage::FileStore.new
      end
    end
  end
end
