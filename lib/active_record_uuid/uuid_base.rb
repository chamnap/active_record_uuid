require File.join(File.dirname(__FILE__), "uuid_base_helper.rb")

class ::ActiveRecord::UuidBase < ::ActiveRecord::Base
  include UuidBaseHelper

  class << self
    def inherited_with_uuid(kls)
      inherited_without_uuid kls
      kls.assign_defaults
    end
    alias_method_chain :inherited, :uuid
  end

  self.descendants.each do |kls|
    kls.assign_defaults
  end

  self.abstract_class = true
end
