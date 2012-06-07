require 'uuidtools'
require 'active_record'

require 'active_record_uuid/uuid_base'
require 'active_record_uuid/railtie' if defined?(Rails)

module ActiveRecordUuid
  autoload :VERSION, 'active_record_uuid/version'
end
