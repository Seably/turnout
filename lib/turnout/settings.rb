module Turnout
  class Settings
    require 'turnout/settings_store'
    require 'turnout/redis_store'
    require 'turnout/maintenance_file'

    def self.storage_class
      case Turnout.config.settings_store
      when :redis
        RedisStore
      else
        MaintenanceFile
      end
    end

    def self.find
      storage_class.find
    end
  end
end
