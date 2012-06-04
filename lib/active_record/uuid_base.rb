require 'uuid_base_helper'

class ActiveRecord::UuidBase < ActiveRecord::Base
  include UuidBaseHelper
	UUID_REG = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{2})([0-9a-f]{2})-([0-9a-f]{12})$/

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