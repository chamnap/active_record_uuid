module ActiveRecordUuid
  class Config
    def initialize(options = {})
      default_options = {
        :column      => :uuid,
        :primary_key => false,
        :association => false,
        :generator   => :timestamp,
        :store_as    => :string,
        :hook        => :before_validation
      }
      options = default_options.merge(options)
      
      options.each_pair do |key, value|
        send(key.to_sym, value)
      end
    end
    
    METHODS = [:column, :primary_key, :association, :generator, :store_as, :hook]
    METHODS.each do |meth|
      define_method(meth.to_sym) do |value=nil|
        instance_variable_set("@#{meth}".to_sym, value) if value.to_s.present?
        instance_variable_get("@#{meth}")
      end
    end
    
    def to_hash
      METHODS.inject({}) do |result, key|
        result[key] = send(key)
        
        result
      end
    end
    
    def validate_options!
      default_generators = [:timestamp, :random]
      raise ArgumentError,
        "Expected :timestamp or :random, got #{@generator}." \
        unless default_generators.include?(@generator)

      default_stores = [:binary, :base64, :hexdigest, :string]
      raise ArgumentError,
        "Expected :binary, :base64, :hexdigest, or :string, got #{@store_as}." \
        unless default_stores.include?(@store_as)
      
      default_hooks = [:before_validation, :after_initialize, :before_create]
      raise ArgumentError,
        "Expected :before_validation, :after_initialize, or :before_create, got #{hook}." \
        unless default_hooks.include?(@hook)
    end
  end
end
