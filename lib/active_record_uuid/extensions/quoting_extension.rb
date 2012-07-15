module ActiveRecordUuid
  module QuotingExtension
    extend ActiveSupport::Concern
    
    included do
      def quote(value, column = nil)
        return super if column.blank? or !value.instance_of?(String) or value.bytesize != 36
        
        begin
          uuid = UUIDTools::UUID.parse(value)
        rescue ArgumentError, TypeError
          return super
        end

        case column.type
        when :binary
          "x'#{uuid.hexdigest}'"
        when :string
          case column.limit
          when 24
            "'#{Base64.encode64(uuid.raw).strip}'"
          when 32
            "'#{uuid.hexdigest}'"
          else
            "'#{uuid.to_s}'"
          end
        end
      end
    end
  end
end
