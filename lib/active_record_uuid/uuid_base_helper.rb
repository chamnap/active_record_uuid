module UuidBaseHelper
  UUID_REG = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{2})([0-9a-f]{2})-([0-9a-f]{12})$/

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:extend, AssociationMethods)
    base.send(:include, InstanceMethods)
    base.assign_defaults
  end

  module InstanceMethods
    def assign_uuid
      self.id = UUIDTools::UUID.timestamp_create().to_s if self.id.blank?
    end

    def assign_uuid!
      assign_uuid
      save!
    end
  end

  module ClassMethods
    def generate_uuid
      UUIDTools::UUID.send("timestamp_create").to_s
    end
    
    def assign_defaults
      self.primary_key            = 'uuid'
      self.before_create          :assign_uuid
      self.validates_format_of    :uuid, :with => UUID_REG, :if => Proc.new { |r| r.id.present? }
    end
  end
  
  module AssociationMethods
    def has_many(name, options = {}, &extension)
      options = default_assoc_options(:has_many, name, options)
      super
    end
    
    def has_one(name, options = {})
      options = default_assoc_options(:has_one, name, options)
      super
    end
    
    def belongs_to(name, options = {})
      options = default_assoc_options(:belongs_to, name, options)
      super
    end

    def has_and_belongs_to_many(name, options = {}, &extension)
      options = default_assoc_options(:has_and_belongs_to_many, name, options)
      super
    end
    
    private
    def default_assoc_options(macro, association_name, options)
      opts = {}
      
      # Set class_name only if not a has-through relation or poly relation
      if options[:through].blank? and options[:as].blank? and options[:class_name].blank? and !self.name.match(/::/)
        opts[:class_name] = "::#{association_name.to_s.singularize.camelize}"
      end
      
      # Set foreign_key only if not passed
      if options[:foreign_key].blank?
        case macro
        when :has_many, :has_one
          opts[:foreign_key] = __to_foreign_key(self.name)
        when :belongs_to
          opts[:foreign_key] = __to_foreign_key(association_name)
        when :has_and_belongs_to_many
          opts[:foreign_key] = __to_foreign_key(self.name)
          opts[:association_foreign_key] = __to_foreign_key(association_name)
        end
      end

      options.merge(opts)
    end
    
    def __to_foreign_key(name)
      name.to_s.singularize.underscore.downcase + "_uuid"
    end
  end
end
