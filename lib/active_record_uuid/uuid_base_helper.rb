module UuidBaseHelper
  def self.included(base)
    warn "[DEPRECATION] `UuidBaseHelper` and `ActiveRecord::UuidBase` are deprecated.  Please inherit from `ActiveRecord::Base` and use `uuid_config` instead."
    
    base.send(:include, ActiveRecordUuid::Model)
    base.uuid_config do
      primary_key true
      association true
      hook        :before_create
    end
  end
end
