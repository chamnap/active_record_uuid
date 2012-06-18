module ActiveRecordUuid
  class Railtie < Rails::Railtie
    config.active_record.schema_format = :sql
    
    initializer :after => 'active_record.initialize_database' do
    
      ActiveSupport.on_load(:active_record) do |app|
        require 'active_record_uuid/extensions/quoting_extension'
        
        ::ActiveRecord::UuidBase.connection.class.send :include, ActiveRecordUuid::QuotingExtension
      end
    end
    
  	rake_tasks do
      load "active_record_uuid/rails/db.rake"
    end
  end
end
