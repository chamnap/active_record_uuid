require 'active_support/concern'

module UuidBaseHelper
	extend ActiveSupport::Concern
	UUID_REG = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{2})([0-9a-f]{2})-([0-9a-f]{12})$/

	included do
		def assign_uuid
	  	self.id = UUIDTools::UUID.timestamp_create().to_s if id.blank?
		end

		def assign_uuid!
			assign_uuid
			save!
		end
	end

	module ClassMethods
    def assign_defaults
      self.primary_key 				= 'uuid'
      self.inheritance_column = 'ruby_type'
      self.before_create         :assign_uuid
      self.validates_format_of   :uuid,   :with => UUID_REG, :if => Proc.new { |r| r.id.present? }
    end
	end
end