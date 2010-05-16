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

begin
  require 'spec/rake/spectask'
  desc "Run the tests"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts = ["--format", "specdoc", "--color"]
    t.spec_files = Dir.glob('spec/**/*_spec.rb')
    
    Dir.mkdir('spec/db') if not File.directory?('spec/db')
  end
rescue LoadError
  puts "Rspec not available. Install it with: gem install rspec"
end
