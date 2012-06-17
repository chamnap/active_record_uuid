require 'uuidtools'
require 'base64'
require 'active_record'
require 'active_support/concern'

module ActiveRecordUuid
  autoload :VERSION,            'active_record_uuid/version'
  autoload :Config,             'active_record_uuid/config'
  autoload :Serializer,         'active_record_uuid/serializer'
  autoload :AssociationMethods, 'active_record_uuid/association_methods'
end

require 'active_record_uuid/uuid_base'
require 'active_record_uuid/rails/railtie' if defined?(Rails::Railtie)
