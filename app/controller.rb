require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require :default
Dir.glob(File.expand_path(File.dirname(__FILE__)+'/models/*.rb')).each{|f| require f}

Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('semprenalista')
  end
end

@@subscriber = Subscriber.new
@@subscriber.add_nightclub Nightclub.new YAML::load_file 'cabaret.yml'
@@subscriber.add_nightclub Nightclub.new YAML::load_file 'beco.yml'
every_monday_midday = '0 12 * * 1'
Rufus::Scheduler.start_new.cron every_monday_midday do
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
    name = params[:name]
    email = params[:email]
    friends = params[:friends].values.map{ |f| f if !f.empty? }
    raver = Nightclubber.new name, email, friends
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

get '/subscribe_everybody' do
  @@subscriber.subscribe_everybody
  'Done! Check out the server logs.'
end
