module ActiveRecordUuid
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<DESC
Description:
  Copies ActiveRecordUuid configuration file to your application's initializer directory.
DESC

      def copy_config_file
        template 'active_record_uuid_config.rb', 'config/initializers/active_record_uuid_config.rb'
      end
    end
  end
end
