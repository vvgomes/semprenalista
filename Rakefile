require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec

task :server do
  ruby 'app/controller.rb'
end

task :deploy do
  #run the heroko stuff
end

task :default => :spec