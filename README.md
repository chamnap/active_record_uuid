# ActiveRecordUuid

`active_record_uuid` is a nice and simple gem that add uuid support to your `activerecord` models, `associations`, and `schema.rb`.

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_uuid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_uuid

## Usage

There are two ways you can use this gem: by `inherit` and `include`.

    class Post < ActiveRecord::UuidBase
    end

Or

    class Post < ActiveRecord::Base
      include UuidBaseHelper
    end

You include `UuidBaseHelper` to your model when your is already inherited from other class (STI, ...).

This gems does the following:

1. set primary_key to `uuid`

2. generate the `uuid` value before it saves to the database

3. validate the format of `uuid`


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


4. This above code expects that you have foreign_keys with `_uuid`, so you don't have to pass `:foreign_key` option inside association methods. Other associations options would work as usual, and you can overwrite this behavior as well.

    class Post < ActiveRecord::UuidBase
      has_many :comments, :foreign_key => "comment_id", :inverse_of => :post
    end

5. It also corrects the `schema.rb` to reflect that `uuid` is not an auto-increment integer primary_key so that your tests could work well.

    # assign a uuid
    @post.assign_uuid

    # assign a uuid and save immediately
    @post.assign_uuid!

    # generate to a uuid
    Post.generate_uuid
