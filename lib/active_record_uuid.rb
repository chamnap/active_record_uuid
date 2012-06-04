require 'uuidtools'
require 'active_record'
require "active_record_uuid/version"

module ActiveRecordUuid
  class ActiveRecord::UuidBase < ActiveRecord::Base
  	UUID_REG = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{2})([0-9a-f]{2})-([0-9a-f]{12})$/

	  class << self
	    def inherited_with_uuid(kls)
	      inherited_without_uuid kls
	      kls.assign_defaults
	    end
	    alias_method_chain :inherited, :uuid

	    def assign_defaults
	      self.primary_key 				= 'uuid'
	      self.inheritance_column = 'ruby_type'
	      self.before_create         :assign_uuid
	      self.validates_format_of   :uuid,   :with => UUID_REG, :if => Proc.new { |r| r.id.present? }
	    end
  	end

  	self.descendants.each do |kls|
	  	kls.assign_defaults
	  end

    self.abstract_class = true

  	def assign_uuid
    	self.id = UUIDTools::UUID.timestamp_create().to_s if id.blank?
  	end

  	def assign_uuid!
  		assign_uuid
  		save!
  	end
  end
end
