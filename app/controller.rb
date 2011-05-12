require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require :default
Dir.glob(File.expand_path(File.dirname(__FILE__)+'/models/*.rb')).each{|f| require f}

@@subscriber = Subscriber.new
@@subscriber.add_nightclub Nightclub.new YAML::load_file 'cabaret.yml'
@@subscriber.add_nightclub Nightclub.new YAML::load_file 'beco.yml'
Rufus::Scheduler.start_new.cron '0 12 * * 1' do
    @@subscriber.subscribe_everybody
end

configure do
  enable :sessions
  set :app_file, __FILE__
  set :public, File.dirname(__FILE__)+'/../public'
  set :views, File.dirname(__FILE__)+'/views'
end

helpers do
  def subscribe_new_nightclubber params
    raver = Nightclubber.new params[:name], params[:email]
    params[:friends].values.each do |friend|
      raver.take friend if !friend.empty?
    end
    @@subscriber.subscribe raver
    @@subscriber.add raver
  end
end

get '/' do
  haml  :index
end

post '/subscribe' do
  session[:subscribed] = true
  subscribe_new_nightclubber params
  redirect to '/done'
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end