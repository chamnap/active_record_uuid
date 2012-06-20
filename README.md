# ActiveRecordUuid

`active_record_uuid` is a nice gem that add uuid supports to your `activerecord` models (MySQL). It allows you to store uuid in various formats: binary (16 bytes), base64 (24 bytes), hexdigest (32 bytes), or string (36 bytes), and query back with uuid string.

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_uuid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_uuid
    
## Upgrade from version 0.0.1

`ActiveRecordBase::UuidBase` and `UuidBaseHelper` are depreciated. Right now, you can configure your model by using `uuid_config` and inherit from `ActiveRecord::Base`. Check out the usage below.

## Usage

If you need to use `uuid` column as primary key, don't add any `:primary_key` in migration file, because it will make that column as auto-increment integer primary key. Instead, do something like this:

    create_table :posts, :force => true, :id => false do |t|
      t.string :uuid, :limit => 36
      t.string :text
      t.timestamps
    end

    $ rake db:add_primary_keys            # Add primary keys to all models
    $ rake db:add_primary_key[model_name] # Add primary key to a model

The performance issues arises when you store primary key in large data size. You have two options:
- use `auto-increment` primary key along with uuid column
- use `uuid` primary key, but store in binary format

You have various choices when storing uuid:
- binary format, 16 bytes
- base64 format, 24 bytes (encode uuid into base64)
- hexdigest, 32 bytes string (compact uuid format, without dash)
- string, 36 bytes string (full length uuid)

### Migration

In order for the gem to work well, you need to specify the column `type` and `limit` correctly according to your `uuid_config` (`store_as`).

    create_table :posts, :force => true, :id => false do |t|
      t.binary :uuid, :limit => 16 # must set to the correct value
      t.string :text
      t.timestamps
    end
    
    class Post < ActiveRecord::Base
      uuid_config do
        primary_key true
        store_as    :binary
      end
    end

### Configuring your model

To use uuid in your model, call `uuid_config` in your model.

    class Post < ActiveRecord::Base
      uuid_config do
        column      :uuid       # :uuid is default
        primary_key true        # false is default
        association false       # false is default
        generator   :timestamp  # :timestamp is default
        store_as    :string     # :string is default
        hook        :before_create # :before_validation is default
      end
    end
    
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

### Avaliable options inside `uuid_config`
#### `column` option

Set the column name to store uuid value.

#### `primary_key` option

Specify whether the value of `column` is primary key or not.

#### `generator` option

Specify which generator amongs `[:random, :timestamp]` used to generate `uuid` value.

#### `store_as` option

Specify which format to store. Possible values are `[:binary, :base64, :hexdigest, :string]`.

#### `hook` option

Specify the activerecord hook `[:after_initialize, :before_validation, :before_create]` to generate uuid value. Assign it to `:after_intialize` when you want to associate this record to its children.

#### `assoication` option

When you set this option to `true`, it expects you have foreign_keys with `_uuid`. Therefore, you don't have to pass `:foreign_key` option inside association methods

    class Author < ActiveRecord::Base
      uuid_config do
        primary_key true
        association true
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
        primary_key true
        association true
      end
      belongs_to :post
    end

    # overwrite :foreign_key option and add additional option
    class Post < ActiveRecord::Base
      uuid_config do
        primary_key true
        association true
      end
      has_many :comments, :foreign_key => "comment_id", :inverse_of => :post
    end
    
## Testing
This gem will set the format for dumping the database schema to `:sql`. This means that it is no longer dump the schema to ruby code but database-independent version, `db/structure.sql`. Therefore, you would not have any problems when running the tests.

## References
- [http://www.mysqlperformanceblog.com/2007/03/13/to-uuid-or-not-to-uuid/](http://www.mysqlperformanceblog.com/2007/03/13/to-uuid-or-not-to-uuid/)
