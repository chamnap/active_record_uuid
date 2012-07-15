require 'uuidtools'
require 'base64'
require 'active_record'
require 'active_support/concern'

module ActiveRecordUuid
  autoload :VERSION,            'active_record_uuid/version'
  autoload :Config,             'active_record_uuid/config'
  autoload :Serializer,         'active_record_uuid/serializer'
  autoload :AssociationMethods, 'active_record_uuid/extensions/association_methods'
  autoload :QuotingExtension,   'active_record_uuid/extensions/quoting_extension'
  autoload :Model,              'active_record_uuid/model'
  autoload :Hooks,              'active_record_uuid/hooks'
  
  def self.configure(&block)
    @config = ActiveRecordUuid::Config.new
    @config.instance_eval(&block)
    @config.validate_options!
  end
  
  def self.config
    @config || ActiveRecordUuid::Config.new
  end
end

require 'active_record_uuid/uuid_base'
require 'active_record_uuid/rails/railtie' if defined?(Rails::Railtie)
