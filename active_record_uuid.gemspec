# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_record_uuid/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chamnap"]
  gem.email         = ["chamnapchhorn@gmail.com"]
  gem.description   = %q{A nice gem to add uuids to your models, associations, and schema.rb}
  gem.summary       = %q{A gem for adding uuids to your active record models}
  gem.homepage      = "https://github.com/chamnap/active_record_uuid"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_record_uuid"
  gem.require_paths = ["lib"]
  gem.version       = ActiveRecordUuid::VERSION
  
  gem.add_development_dependency "bundler", ">= 1.1.3"
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "mysql2"
  gem.add_dependency "activerecord", "~> 3.0"
  gem.add_dependency "uuidtools", "~> 2.1.2"
end
