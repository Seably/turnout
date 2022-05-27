module Turnout
  class Settings
    require 'turnout/settings_store'
    require 'turnout/redis_store'
    require 'turnout/maintenance_file'

    def self.find
      case Turnout.config.settings_store
      when :redis
        RedisStore.find
      else
        MaintenanceFile.find
      end
    end
  end
end
