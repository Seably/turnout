module Turnout
  class Settings
    require 'turnout/settings_store'
    require 'turnout/redis_store'
    require 'turnout/maintenance_file'

    def self.storage
      case Turnout.config.settings_store
      when :redis
        RedisStore.new
      else
        MaintenanceFile.new
      end
    end
  end
end
