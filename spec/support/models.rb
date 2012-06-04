class PostInherit < ActiveRecord::UuidBase
	self.table_name = "posts"
end

class PostInclude < ActiveRecord::Base
	include UuidBaseHelper
	self.table_name = "posts"
end