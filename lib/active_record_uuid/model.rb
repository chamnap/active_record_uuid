module ActiveRecordUuid::Model
  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
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
 
    def uuid_value
      send(uuid_column)
    end
    
    private
    def uuid_config
      self.class.uuid_config
    end
    
    def assign_uuid_when_blank
      assign_uuid if uuid_value.blank?
    end
    
    def uuid_column
      uuid_config.column
    end
    
    def validates_uuid
      errors.add(uuid_column, "is invalid format") unless uuid_valid?
    end
  end

  module ClassMethods
    def generate_uuid
      UUIDTools::UUID.send("#{uuid_config.generator}_create").to_s
    end
    
    def uuid_config(&block)
      return @uuid_config if @uuid_config.present?
      
      @uuid_config = ActiveRecordUuid::Config.new
      if block_given?
        @uuid_config.instance_eval(&block)
        @uuid_config.validate_options!
      end
      
      # apply uuid based on config
      has_uuid(@uuid_config.to_hash)
      
      @uuid_config
    end
    
    def has_uuid(options = {})
      options = ActiveRecordUuid.config.to_hash.merge(options)
      @uuid_config = ActiveRecordUuid::Config.new(options)
      
      column_name = uuid_config.column.to_sym
      self.primary_key              = column_name if uuid_config.primary_key
      self.serialize                column_name, ActiveRecordUuid::Serializer.new(uuid_config.store_as)
      self.send(uuid_config.hook,   :assign_uuid_when_blank)
      self.validates_uniqueness_of  column_name, :if => Proc.new { |r| r.uuid_value.present? }
      self.validate                 :validates_uuid, :if => Proc.new { |r| r.uuid_value.present? }
      self.send(:extend, ActiveRecordUuid::AssociationMethods) if uuid_config.association
    end
  end
end
