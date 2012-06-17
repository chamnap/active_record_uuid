require 'active_record_uuid'

db_config = {
  :adapter => "mysql2", 
  :database => "active_record_uuid",
  :user => "root",
  :password => "Q1p2m3g4"
}

ActiveRecord::Base.establish_connection(db_config) rescue nil
ActiveRecord::Base.connection.drop_database(db_config[:database]) rescue nil
ActiveRecord::Base.establish_connection(db_config.merge(:database => nil))
ActiveRecord::Base.connection.create_database(db_config[:database], { :charset => 'utf8', :collation => 'utf8_unicode_ci' })
ActiveRecord::Base.establish_connection(db_config)

# load extension
require 'active_record_uuid/extensions/quoting_extension'
::ActiveRecord::Base.connection.class.send :include, ActiveRecordUuid::QuotingExtension

# load support
load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
