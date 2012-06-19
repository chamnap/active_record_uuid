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
    def assign_uuid_when_blank
      assign_uuid if uuid_value.blank?
    end
    
    def uuid_column
      self.class.uuid_config.column
    end
    
    def validates_uuid
      errors.add(uuid_column, "is invalid format") unless uuid_valid?
    end
  end

  module ClassMethods 
    def uuid_config(&block)
      return @config if @config.present?
      
      @config = ActiveRecordUuid::Config.new
      @config.instance_eval(&block) if block_given?
      @config.validate_options!

      column_name = @config.column.to_sym
      self.primary_key              = column_name if @config.primary_key
      self.serialize                column_name, ActiveRecordUuid::Serializer.new(@config.store_as)
      self.send(@config.hook,       :assign_uuid_when_blank)
      self.validates_uniqueness_of  column_name, :if => Proc.new { |r| r.uuid_value.present? }
      self.validate                 :validates_uuid , :if => Proc.new { |r| r.uuid_value.present? }
      self.send(:extend, ActiveRecordUuid::AssociationMethods) if @config.association
      
      @config
    end
    
    def generate_uuid
      UUIDTools::UUID.send("#{uuid_config.generator}_create").to_s
    end
  end
end
