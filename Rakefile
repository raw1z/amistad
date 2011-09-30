require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec'
require 'rspec/core/rake_task'

namespace :spec do
  Rspec::Core::RakeTask.new(:activerecord) do |t|
    t.pattern = "./spec/activerecord/**/*_spec.rb"
    t.rspec_opts = "--format Fuubar"
  end

  Rspec::Core::RakeTask.new(:mongoid) do |t|
    t.pattern = "./spec/mongoid/**/*_spec.rb"
    t.rspec_opts = "--format Fuubar"
  end
end

task :default do
  Rake::Task['spec:activerecord'].invoke
  Rake::Task['spec:mongoid'].invoke
end
