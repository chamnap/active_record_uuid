module ActiveRecordUuid
  module AssociationMethods
    def has_many(name, options = {}, &extension)
      options = uuid_assoc_options(:has_many, name, options)
      super
    end
    
    def has_one(name, options = {})
      options = uuid_assoc_options(:has_one, name, options)
      super
    end
    
    def belongs_to(name, options = {})
      options = uuid_assoc_options(:belongs_to, name, options)
      super
    end

    def has_and_belongs_to_many(name, options = {}, &extension)
      options = uuid_assoc_options(:has_and_belongs_to_many, name, options)
      super
    end
    
    private
    def uuid_assoc_options(macro, association_name, options)
      opts = {}
      
      # Set class_name only if not a has-through relation or poly relation
      if options[:through].blank? and options[:as].blank? and options[:class_name].blank? and !self.name.match(/::/)
        opts[:class_name] = "::#{association_name.to_s.singularize.camelize}"
      end
      
      # Set foreign_key only if not passed
      if options[:foreign_key].blank?
        case macro
        when :has_many, :has_one
          opts[:foreign_key] = uuid_foreign_key(self.name)
        when :belongs_to
          opts[:foreign_key] = uuid_foreign_key(association_name)
        when :has_and_belongs_to_many
          opts[:foreign_key] = uuid_foreign_key(self.name)
          opts[:association_foreign_key] = uuid_foreign_key(association_name)
        end
      end

      options.merge(opts)
    end
    
    def uuid_foreign_key(name)
      name.to_s.singularize.underscore.downcase + "_uuid"
    end
  end
end
