module ActiveRecordUuid
  class Railtie < Rails::Railtie
  	rake_tasks do
      load "active_record_uuid/tasks/db.rake"
    end
  end
end
