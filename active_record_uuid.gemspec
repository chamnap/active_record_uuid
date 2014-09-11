# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_record_uuid/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chamnap"]
  gem.email         = ["chamnapchhorn@gmail.com"]
  gem.description   = %q{active_record_uuid is a nice gem that add uuid supports to your activerecord models (MySQL). It allows you to store uuid in various formats: binary (16 bytes), base64 (24 bytes), hexdigest (32 bytes), or string (36 bytes), and query back with uuid string.}
  gem.summary       = %q{A full-featured gem for adding uuid support to your active record models}
  gem.homepage      = "https://github.com/chamnap/active_record_uuid"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_record_uuid"
  gem.require_paths = ["lib"]
  gem.version       = ActiveRecordUuid::VERSION
  gem.license       = "MIT"

  gem.required_ruby_version     = '>= 1.9.3'
  gem.required_rubygems_version = '>= 1.8.11'

  gem.add_development_dependency "rake", "~> 10.1.0"
  gem.add_development_dependency "bundler", ">= 1.3.5"
  gem.add_development_dependency "rspec", "~> 2.12.0"
  gem.add_development_dependency "pry", "~> 0.9.12.3"

  gem.add_dependency "activerecord", ">= 3.2"
  gem.add_dependency "uuidtools", "~> 2.1.2"
end
