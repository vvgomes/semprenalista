require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'rake'

Bundler.require :test
require 'rspec/core/rake_task'

task :default => :spec

n = namespace :spec do
  RSpec::Core::RakeTask.new(:models) do |spec|
    spec.pattern = 'spec/models/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:integration) do |spec|
    spec.pattern = 'spec/integration/**/*_spec.rb'
  end
end

task :spec => [n[:models], n[:integration]]

task :server do
  ruby 'app/controller.rb'
end

desc 'This task is called by the Heroku cron add-on'
task :cron do
  Job.new(Subscriber.create).run
end

task :subscribe do
  puts "[#{Time.now}] Job started."
  Job.new(Subscriber.create).run_now
  puts "[#{Time.now}] Job done."
end