# ActiveRecordUuid

`active_record_uuid` is a nice and simple gem that add uuid support to your `activerecord` models, `associations`, `schema.rb`, and `rake script`.

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_uuid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_uuid

## Usage

This gem doesn't try to overwrite anything, it just makes use of existing activerecord apis in order to work with `uuid`.

In your migration files, you don't add any `:primary`, because it will make that column as auto-increment integer primary key. Do something like this:

    create_table :posts, :force => true, :id => false do |t|
      t.string :uuid, :limit => 36
      t.string :text
      t.timestamps
    end
    
Add primary keys to all tables

    $ rake db:add_primary_keys

There are two ways you can use this gem: by `inherit` and `include`.

    class Post < ActiveRecord::UuidBase
    end

Or

    class Post < ActiveRecord::Base
      include UuidBaseHelper
    end

You include `UuidBaseHelper` to your model when your model is already inherited from other classes (STI, ...).

    # create a post with auto-generated uuid
    post = Post.new(:text => "Manual uuid")
    post.save
    post.uuid   # "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
    
    # create a post with manual uuid
    post = Post.new(:text => "Manual uuid")
    post.uuid = "79f8a42e-ae60-11e1-9aa9-0026b90faf3c"
    post.save
    
    # assign a uuid
    @post.assign_uuid

    # assign a uuid and save immediately
    @post.assign_uuid!

    # generate to a uuid
    Post.generate_uuid

    # It expects you have foreign_keys with `_uuid`
    # you don't have to pass `:foreign_key` option inside association methods
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

    # overwrite :foreign_key option and add additional option
    class Post < ActiveRecord::UuidBase
      has_many :comments, :foreign_key => "comment_id", :inverse_of => :post
    end
