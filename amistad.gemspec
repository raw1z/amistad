# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amistad/version"

Gem::Specification.new do |s|
  s.name        = "amistad"
  s.version     = Amistad::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rawane ZOSSOU"]
  s.email       = ["dev@raw1z.fr"]
  s.homepage    = "https://github.com/raw1z/amistad/wiki"
  s.summary     = %q{Adds friendships management into a rails 3.0 application}
  s.description = %q{Extends your user model with friendships management methods}

  s.rubyforge_project = "amistad"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mongoid", "~> 2.0.0"
  s.add_development_dependency "bson_ext", "~> 1.3"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "awesome_print"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
