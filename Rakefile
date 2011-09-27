require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

task :default => :spec

n = namespace :spec do

  RSpec::Core::RakeTask.new(:models) do |spec|
    spec.pattern = 'spec/models/*_spec.rb'
    spec.rspec_opts = ['--backtrace']
  end

  RSpec::Core::RakeTask.new(:integration) do |spec|
    spec.pattern = 'spec/integration/*_spec.rb'
    spec.rspec_opts = ['--backtrace']
  end
end

task :spec => [n[:models], n[:integration]]

task :server do
  ruby 'app/controller.rb'
end

