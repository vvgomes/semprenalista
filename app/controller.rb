require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require :default

Dir.glob(File.expand_path(File.dirname(__FILE__)+'/models/*.rb')).each{|f| require f}

configure do
  enable :sessions
  set :app_file, __FILE__
  set :public, File.dirname(__FILE__)+'/../public'
  set :views, File.dirname(__FILE__)+'/views'
  
  @@subscriber = Subscriber.new
end

before do
  # startup:
  @@subscriber.add_nightclub Nightclub.new YAML::load_file 'cabaret.yaml'
  @@subscriber.add_nightclub Nightclub.new YAML::load_file 'beco.yaml'
  # the scheduller tell @subscriber.subscribe_everybody every monday
end

get '/' do
  haml  :index
end

post '/subscribe' do
  session[:subscribed] = true
  
  raver = Nightclubber.new params[:name], params[:email]
  params[:friends].values.each do |friend|
    raver.take friend if !friend.empty?
  end
  #@subscriber.subscribe raver
  @@subscriber.add raver
  
  redirect to '/done'
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end