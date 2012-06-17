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

        hex_digest = value.gsub('-', '')
        case column.type
        when :binary
          "BINARY x'#{hex_digest}'"
        when :string
          case value.length
          when 24
            "'#{Base64.encode64(hex_digest)}'"
          when 32
            "'#{hex_digest}'"
          when 36
            "'#{value}'"
          end
        end
      end
    end
  end
end
