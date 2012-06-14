module ActiveRecordUuid
  class Config
    def column(value=:uuid)
      @column = value.to_sym
      @column
    end
    
    def primary_key(value=false)
      @primary_key = value
      @primary_key
    end
    
    def association(value=false)
      @association = value
      @association
    end
    
    def generator(name=:timestamp)
      defaults = [:timestamp, :random]
      raise ArgumentError,
          "Expected :timestamp or :random, got #{name}." unless defaults.include?(name)
      
      @generator = name
      @generator
    end
    
    def store_as(type=:string)
      defaults = [:binary, :base64, :hexdigest, :string]
      raise ArgumentError,
          "Expected :binary, :base64, :hexdigest, or :string, got #{type}." unless defaults.include?(type)
      
      @store_as = type
      @store_as
    end
  end
end
