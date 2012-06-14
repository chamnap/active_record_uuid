module UuidBaseHelper
  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
    base.assign_defaults
  end

  module InstanceMethods
    def assign_uuid
      send("#{uuid_column}=", self.class.generate_uuid)
    end

    def assign_uuid!
      assign_uuid
      save!
    end
     
    def uuid_valid?
      begin
        UUIDTools::UUID.parse(uuid_value).valid?
      rescue ArgumentError, TypeError
        false
      end
    end
    
    private
    def assign_uuid_when_blank
      assign_uuid if uuid_value.blank?
    end
    
    def uuid_column
      self.class.uuid_base.column
    end
    
    def uuid_value
      send(uuid_column)
    end
    
    def validates_uuid
      errors.add(uuid_column, "is invalid format") unless uuid_valid?
    end
  end

  module ClassMethods 
    def uuid_base(&block)
      @config ||= ActiveRecordUuid::Config.new
      @config.instance_eval(&block) if block_given?
      @config
    end
    
    def generate_uuid
      uuid = UUIDTools::UUID.send("#{uuid_base.generator}_create")
      
      case uuid_base.store_as
      when :base64
        Base64.encode64(uuid.raw)[0..-2]
      when :binary
        uuid.raw
      when :hexdigest
        uuid.hexdigest
      else
        uuid.to_s
      end
    end
    
    def assign_defaults
      column_name                   = uuid_base.column
      
      self.before_validation        :assign_uuid_when_blank
      self.validate                 :validates_uuid
      self.primary_key              = column_name if uuid_base.primary_key
      self.validates_uniqueness_of  column_name
      self.serialize                column_name, ActiveRecordUuid::Serializer.new(uuid_base.store_as)
      self.send(:extend, ActiveRecordUuid::AssociationMethods) if uuid_base.association
    end
  end
end
