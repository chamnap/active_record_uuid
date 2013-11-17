# ActiveRecordUuid [![Build Status](https://travis-ci.org/chamnap/active_record_uuid.png?branch=master)](https://travis-ci.org/chamnap/active_record_uuid) [![Gem Version](https://badge.fury.io/rb/active_record_uuid.png)](http://badge.fury.io/rb/active_record_uuid) [![Dependency Status](https://gemnasium.com/chamnap/active_record_uuid.png)](https://gemnasium.com/chamnap/active_record_uuid)

`active_record_uuid` is a nice gem that add uuid supports to your `activerecord` models (MySQL). It allows you to store uuid in various formats: binary (16 bytes), base64 (24 bytes), hexdigest (32 bytes), or string (36 bytes), and query back with uuid string.

The performance issues arises when you store primary key in large data size. You have two options:
- use `auto-increment` primary key along with uuid column
- use `uuid` primary key, but store in binary format

You have various choices when storing uuid:
- binary format, 16 bytes
- base64 format, 24 bytes (encode uuid into base64)
- hexdigest, 32 bytes string (compact uuid format, without dash)
- string, 36 bytes string (full length uuid)

Check this out for more detail, [http://www.mysqlperformanceblog.com/2007/03/13/to-uuid-or-not-to-uuid/](http://www.mysqlperformanceblog.com/2007/03/13/to-uuid-or-not-to-uuid/).

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_uuid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_uuid
    
## Upgrade from version 0.0.1

`ActiveRecordBase::UuidBase` and `UuidBaseHelper` are depreciated. Right now, you can configure your model by using `has_uuid` and inherit from `ActiveRecord::Base`. Check out the usage below.

## Upgrade from version 0.1.0

`uuid_config` is fine, but I like to use `has_uuid` and passing in options instead.

## Usage

If you need to use `uuid` column as primary key, don't add any `:primary_key` in migration file, because it will make that column as auto-increment integer primary key. Instead, do something like this:

    create_table :posts, :force => true, :id => false do |t|
      t.string :uuid, :limit => 36
      t.string :text
      t.timestamps
    end

    $ rake db:add_primary_keys            # Add primary keys to all models
    $ rake db:add_primary_key[model_name] # Add primary key to a model

### Migration

In order for the gem to work well, you need to specify the column `type` and `limit` correctly according to your `has_uuid` (`store_as` option).

    create_table :posts, :force => true, :id => false do |t|
      t.binary :uuid, :limit => 16 # `must set to the correct value`
      t.string :text
      t.timestamps
    end
    
    class Post < ActiveRecord::Base
      has_uuid :primary_key => true, :store_as => :binary
    end
    
### General configuration options

You can configure using `ActiveRecordUuid.configure`, and it will apply to any models which use `has_uuid`. Each model can overwrite the general options by passing options into `has_uuid`. The following are default values:

    ActiveRecordUuid.configure do
      column      :uuid           # :uuid is default
      primary_key true            # false is default
      association false           # false is default
      generator   :timestamp      # :timestamp is default
      store_as    :string         # :string is default
      hook        :before_create  # :before_validation is default
    end
    
There's a config generator that generates the default configuration file into config/initializers directory.
Run the following generator command, then edit the generated file.

    $ rails g active_record_uuid:config

### Model configuration

To use uuid in your model, call `has_uuid` in your model.

    class Post < ActiveRecord::Base
      has_uuid :primary_key => true, :hook => :before_create
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
    post.assign_uuid

    # assign a uuid and save immediately
    post.assign_uuid!
    
    # check the uuid value is valid or not
    post.uuid_valid?

    # generate a new uuid
    Post.generate_uuid

### Binary uuid model (example)

    class PostBinary < ActiveRecord::Base
      has_uuid :primary_key => true, :store_as => :binary
    end
    
    post = PostBinary.create(:text => "Binary uuid1")
    # INSERT INTO `post_binaries` (`created_at`, `text`, `updated_at`, `uuid`) VALUES ('2012-06-20 17:32:47', 'Binary uuid1', '2012-06-20 17:32:47', x'4748f690bac311e18e440026b90faf3c')
    
    post.uuid # "4748f690-bac3-11e1-8e44-0026b90faf3c"
    
    # it works as usual for finding records
    PostBinary.find_by_uuid(post.uuid)
    PostBinary.where(:uuid => post.uuid)
    PostBinary.find(post)
    PostBinary.find(post.uuid)
    PostBinary.find([post.uuid])
    post.comments.create(:text => "Comment 1")
    
    # access the value that stored in db
    post.reload
    post.attributes_before_type_cast["uuid"]["value"]

### Avaliable options inside `has_uuid`
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
      has_uuid :primary_key => true, :association => true
      has_and_belongs_to_many :posts
    end

    class Post < ActiveRecord::Base
      has_uuid :primary_key => true, :association => true
      has_many :comments
      has_one  :comment
      has_and_belongs_to_many :authors
    end

    class Comment < ActiveRecord::Base
      has_uuid :primary_key => true, :association => true
      belongs_to :post
    end

    # overwrite :foreign_key option and add additional option
    class Post < ActiveRecord::Base
      has_uuid :primary_key => true, :association => true
      has_many :comments, :foreign_key => "comment_id", :inverse_of => :post
    end
    
## Testing
This gem will set the format for dumping the database schema to `:sql`. This means that it is no longer dump the schema to ruby code but database-independent version, `db/structure.sql`. Therefore, you would not have any problems when running the tests.
