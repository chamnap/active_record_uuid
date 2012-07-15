module ActiveRecordUuid
  class Hooks
    def self.init
      ActiveSupport.on_load(:active_record) do |app|
        ::ActiveRecord::Base.connection.class.send :include, ActiveRecordUuid::QuotingExtension
        ::ActiveRecord::Base.send(:include, ActiveRecordUuid::Model)
      end
    end
  end
end
