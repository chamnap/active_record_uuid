module ActiveRecordUuid
  class Config
    METHODS = [:column, :primary_key, :association, :generator, :store_as]
    METHODS.each do |meth|
      define_method(meth.to_sym) do |value=nil|
        instance_variable_set("@#{meth}".to_sym, value) if value
        instance_variable_get("@#{meth}")
      end
    end
    
    def assign_default!
      @column      = :uuid       if @column.nil?
      @primary_key = false       if @primary_key.nil?
      @association = false       if @association.nil?
      @generator   = :timestamp  if @generator.nil?
      @store_as    = :string     if @store_as.nil?
      
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
