class PostInherit < ActiveRecord::UuidBase
  self.table_name = "posts"
end

class PostInclude < ActiveRecord::Base
  include UuidBaseHelper
  self.table_name = "posts"
end

class Author < ActiveRecord::UuidBase
  has_and_belongs_to_many :posts
end

class Post < ActiveRecord::UuidBase
  has_many :comments
  has_one  :comment
  has_and_belongs_to_many :authors
end

class Comment < ActiveRecord::UuidBase
  belongs_to :post
end

class Article < ActiveRecord::UuidBase
  has_many :comments
end
