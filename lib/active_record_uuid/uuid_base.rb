require File.join(File.dirname(__FILE__), "uuid_base_helper.rb")

class ActiveRecord::UuidBase < ::ActiveRecord::Base
  include UuidBaseHelper

  self.abstract_class = true
end
