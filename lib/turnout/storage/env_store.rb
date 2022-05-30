require 'yaml'

module Turnout
  module Storage
    class EnvStore < SettingsStore

      def initialize
        super
        import_yaml if exists?
      end

      def exists?
        ENV.has_key?(Turnout.config.env_key)
      end

      # Do nothing
      def write; end
      def delete; end

      private

      def import_yaml
        import YAML::load(ENV[Turnout.config.env_key]) || {}
      end
    end
  end
end
