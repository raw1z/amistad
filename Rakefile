require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "amistad"
    gemspec.summary = "Adds friendships management into a rails 3.0 application"
    gemspec.description = "Extends your user model with friendships management methods"
    gemspec.email = "dev@raw1z.fr"
    gemspec.homepage = "http://github.com/raw1z/amistad"
    gemspec.authors = ["Rawane ZOSSOU"]
    gemspec.files =  FileList["[A-Z]*", "{lib}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:spec) do |spec|
end

Rspec::Core::RakeTask.new(:rcov) do |spec|
end

task :spec => :check_dependencies

task :default => :spec
