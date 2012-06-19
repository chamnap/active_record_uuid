class Article < ActiveRecord::Base
  uuid_config
  
  has_many :comments
end

class ArticleUuidBase < ActiveRecord::UuidBase
  self.table_name = "articles"

  has_many :comments
end

class PostBinary < ActiveRecord::Base
  uuid_config do
    association true
    primary_key true
    store_as    :binary
  end
  
  has_many :comments
end

class PostBase64 < ActiveRecord::Base
  uuid_config do
    primary_key true
    store_as    :base64
  end
end

class PostHexDigest < ActiveRecord::Base
  uuid_config do
    primary_key true
    store_as    :hexdigest
  end
end

class Author < ActiveRecord::Base
  uuid_config do
    association true
    primary_key true
  end

  has_and_belongs_to_many :posts
end

class Post < ActiveRecord::Base
  uuid_config do
    primary_key true
    association true
  end
  
  has_many :comments
  has_one  :comment
  has_and_belongs_to_many :authors
end

class Comment < ActiveRecord::Base
  uuid_config do
    association true
    primary_key true
  end
  
  belongs_to :post
end
