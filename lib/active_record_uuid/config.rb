module ActiveRecordUuid
  class Config
    def column(value=nil)
      @column = value if value
      @column
    end
    
    def primary_key(value=nil)
      @primary_key = value if value 
      @primary_key
    end
    
    def association(value=nil)
      @association = value if value
      @association
    end
    
    def generator(value=nil)
      @generator = value if value
      @generator
    end
    
    def store_as(value=nil)
      @store_as = value if value
      @store_as
    end
    
    def assign_default!
      @column = :uuid          if @column.nil?
      @primary_key = false     if @primary_key.nil?
      @association = false     if @association.nil?
      @generator = :timestamp  if @generator.nil?
      @store_as = :string      if @store_as.nil?
      
      # raise exception when there is not in the list
      default_generators = [:timestamp, :random]
      raise ArgumentError,
        "Expected :timestamp or :random, got #{@config.store_as}." \
        unless default_generators.include?(@generator)

      default_stores = [:binary, :base64, :hexdigest, :string]
      raise ArgumentError,
        "Expected :binary, :base64, :hexdigest, or :string, got #{@config.store_as}." \
        unless default_stores.include?(@store_as)
    end
  end
end
