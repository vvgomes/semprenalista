require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'rake'
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

desc 'This task is called by the Heroku Scheduler add-on'
task :subscribe do
  #Job.new.run
  puts '>>> RUNING SUBSCRIBE! <o> \o/ <o> \o/ <o> \o/'
end

task :subscribe_now do
  Mongoid.configure do |config|
    production_db = 'mongodb://heroku:iy6k13o77hxc6q5026zttd@flame.mongohq.com:27103/app525158'
    conn = Mongo::Connection.from_uri(production_db)
    uri = URI.parse(production_db)
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  end
  Job.new.run!
end

task :info do
  puts "Number of clubbers: #{Nightclubber.count}"
  puts "Last added: #{Nightclubber.last.to_s}"
end

task :clear_db do
  Nightclubber.delete_all
  Report.delete_all
  puts 'Done.'
end
