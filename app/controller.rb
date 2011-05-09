require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require :default

Dir.glob(File.expand_path(File.dirname(__FILE__)+'/models/*.rb')).each{|f| require f}

set :app_file, __FILE__
set :public, File.dirname(__FILE__)+'/../public'
set :views, File.dirname(__FILE__)+'/views'
enable :sessions

# startup:
@subscriber = Subscriber.new
@subscriber.add_nightclub Nightclub.new YAML::load_file 'cabaret.yaml'
@subscriber.add_nightclub Nightclub.new YAML::load_file 'beco.yaml'
# the scheduller tell @subscriber.subscribe_everybody every monday

get '/' do
  haml  :index
end

post '/subscribe' do
  session[:subscribed] = true
  
  raver = Nightclubber.new params[:name], params[:email]
  params[:friends].values.each do |friend|
    raver.take friend
  end
  @subscriber.subscribe raver
  @subscriber.add raver
  
  redirect to '/done'
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end