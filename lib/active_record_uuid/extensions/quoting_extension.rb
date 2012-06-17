module ActiveRecordUuid
  module QuotingExtension
    extend ActiveSupport::Concern
    
    included do
      def quote_with_uuid(value, column = nil)
        return quote_without_uuid(value, column) if column.blank? or !value.instance_of?(String) or value.bytesize != 36
        
        begin
          uuid = UUIDTools::UUID.parse(value)
        rescue ArgumentError, TypeError
          return quote_without_uuid(value, column)
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
      alias_method_chain :quote, :uuid
      
    end
  end
end
