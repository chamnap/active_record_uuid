class Article < ActiveRecord::UuidBase
  uuid_base
  
  has_many :comments
end

class PostBinary < ActiveRecord::UuidBase
  uuid_base do
    association true
    primary_key true
    store_as    :binary
  end
  
  has_many :comments
end

class Author < ActiveRecord::UuidBase
  uuid_base do
    association true
    primary_key true
  end

  has_and_belongs_to_many :posts
end

class Post < ActiveRecord::UuidBase
  uuid_base do
    primary_key true
    association true
  end
  
  has_many :comments
  has_one  :comment
  has_and_belongs_to_many :authors
end

class Comment < ActiveRecord::UuidBase
  uuid_base do
    association true
    primary_key true
  end
  
  belongs_to :post
end
