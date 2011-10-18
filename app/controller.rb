require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require :default
Dir.glob(File.expand_path(File.dirname(__FILE__)+'/models/**/*.rb')).each{|f| require f}

Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri('mongodb://localhost:27017').db('semprenalista')
  end
end

configure do
  enable :sessions
  set :app_file, __FILE__
  set :public, File.dirname(__FILE__)+'/../public'
  set :views, File.dirname(__FILE__)+'/views'
end

helpers do
  def subscriber
    if !@@subscribber then
      @@subscriber = Subscriber.new
      @@subscriber.add Nightclub.new(Cabaret::Navigator.new)
      @@subscriber.add Nightclub.new(Beco::Navigator.new)
      Robot.new(@@subscriber).work
    end
    @@subscriber
  end
end

get '/' do
  haml :index
end

post '/subscribe' do
  session[:subscribed] = true
  raver = Nightclubber.parse params
  #subscriber.subscribe raver
  raver.save
  redirect to '/done'
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end

get '/nightclubbers' do
  haml :nightclubbers, :locals => {
    :clubbers => Nightclubber.all
  }
end

get '/parties' do
  haml :parties, :locals => {
    :nightclubs => subscriber.nightclubs
  }
end

get '/about' do
  haml :about
end

get '/reports' do
  erb :reports, :locals => {
    :reports => subscriber.reports
  }
end

