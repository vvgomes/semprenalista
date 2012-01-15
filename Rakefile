require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'rake'

unless ENV['RACK_ENV'] == 'production'
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
end


task :server do
  system 'rackup'
end

desc 'This task is called by the Heroku Scheduler add-on'
task :subscribe, :email do |t, args|
  if !args[:email]
    #Job.new.run
    puts '>>> Job disabled due to maintenance.'
  else
    Mongoid.configure do |config|
      production_db = 'mongodb://heroku:iy6k13o77hxc6q5026zttd@flame.mongohq.com:27103/app525158'
      conn = Mongo::Connection.from_uri(production_db)
      uri = URI.parse(production_db)
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    end
    Job.new.run args[:email]
  end  
end
