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
    
    class Post < ActiveRecord::Base
      include UuidBaseHelper
    end
