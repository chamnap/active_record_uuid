module ActiveRecordUuid
  class Serializer
    attr_reader :type
    def initialize(type)
      @type = type
    end

    def load(value)
      return nil if value.nil?

      begin
        uuid = case type
        when :binary
          UUIDTools::UUID.parse_raw(value)
        when :base64
          UUIDTools::UUID.parse_raw(Base64.decode64(value))
        when :hexdigest
          UUIDTools::UUID.parse_hexdigest(value)
        when :string
          UUIDTools::UUID.parse(value)
        end
        raise ArgumentError unless uuid.valid?

        uuid.to_s
      rescue ArgumentError, TypeError
        raise ActiveRecord::SerializationTypeMismatch,
          "Attribute was supposed to be a valid uuid, but was #{value}"
      end
    end

    def dump(value)
      uuid = begin
        UUIDTools::UUID.parse(value)
      rescue ArgumentError, TypeError
        nil
      end

      case type
      when :binary
        uuid.raw
      when :base64
        Base64.encode64(uuid.raw).strip
      when :hexdigest
        uuid.hexdigest
      when :string
        uuid.to_s
      end
    end
  end
end
