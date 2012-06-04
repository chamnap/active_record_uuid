require 'active_record_uuid'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", 
  :database => File.dirname(__FILE__) + "/active_record_uuid.sqlite3"
)

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'