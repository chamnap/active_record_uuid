require 'active_record_uuid'
require 'pry'

db_config = {
  :adapter => "mysql2",
  :database => "active_record_uuid",
  :user => "root",
  :password => ""
}

ActiveRecord::Base.establish_connection(db_config) rescue nil
ActiveRecord::Base.connection.drop_database(db_config[:database]) rescue nil
ActiveRecord::Base.establish_connection(db_config.merge(:database => nil))
ActiveRecord::Base.connection.create_database(db_config[:database], { :charset => 'utf8', :collation => 'utf8_unicode_ci' })
ActiveRecord::Base.establish_connection(db_config)

# load hooks
ActiveRecordUuid::Hooks.init

# load support
load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end