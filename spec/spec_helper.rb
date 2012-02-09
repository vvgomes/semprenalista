require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require File.expand_path(File.dirname(__FILE__) + '/../app/controller')
require 'capybara/rspec'
Capybara.app = Sinatra::Application