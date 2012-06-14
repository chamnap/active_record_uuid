module ActiveRecordUuid
  module Rails
    class Railtie < Rails::Railtie
    	rake_tasks do
        load "active_record_uuid/rails/db.rake"
      end
    end
  end
end
