require File.join(File.dirname(__FILE__), "uuid_base_helper.rb")

class ActiveRecord::UuidBase < ::ActiveRecord::Base
  class << self
    def inherited_with_uuid(kls)
      inherited_without_uuid kls
      warn "[DEPRECATION] `UuidBaseHelper` and `ActiveRecord::UuidBase` are deprecated.  Please inherit from `ActiveRecord::Base` and use `has_uuid` instead."
      kls.uuid_config do
        primary_key true
        association true
        hook        :before_create
      end
    end
    alias_method_chain :inherited, :uuid
  end

  self.descendants.each do |kls|
    warn "[DEPRECATION] `UuidBaseHelper` and `ActiveRecord::UuidBase` are deprecated.  Please inherit from `ActiveRecord::Base` and use `has_uuid` instead."
    kls.uuid_config do
      primary_key true
      association true
      hook        :before_create
    end
  end

  self.abstract_class = true
end
