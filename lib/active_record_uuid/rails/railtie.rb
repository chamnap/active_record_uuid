module ActiveRecordUuid
  class Railtie < Rails::Railtie
    config.active_record.schema_format = :sql
    
    initializer :after => 'active_record.initialize_database' do
      ActiveRecordUuid::Hooks.init
    end
    
    rake_tasks do
      load "active_record_uuid/rails/db.rake"
    end
    
    generators do
      require 'active_record_uuid/rails/generators/config_generator'
    end
  end
end
