require 'yaml'

module Turnout
  class Settings
    def self.find
      case Turnout.config.session_store
      when :redis
        Turnout::RedisStore.find
      else
        Turnout::MaintenanceFile.find
      end
    end
  end
end
