module Turnout
  class Settings
    require 'turnout/storage/settings_store'
    require 'turnout/storage/redis'
    require 'turnout/storage/file'

    def self.storage
      case Turnout.config.settings_store
      when :redis
        Storage::Redis.new
      else
        Storage::File.new
      end
    end
  end
end
