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
    config.master = Mongo::Connection.
      from_uri('mongodb://localhost:27017').
      db('semprenalista')
  end
end

configure do
  enable :sessions
  use Rack::Flash, :sweep => true
  set :app_file, __FILE__
  set :public, File.dirname(__FILE__)+'/../public'
  set :views, File.dirname(__FILE__)+'/views'
end

helpers do
  def subscriber
    if !@subscriber
      @subscriber = Subscriber.create
      Robot.new(@subscriber).work
    end
    @subscriber
  end

  def nightclubbers_names
    Nightclubber.sorted_names
  end

  def nightclubs
    subscriber.nightclubs
  end

  def reports
    subscriber.reports
  end
end

get '/' do
  @clubber = Nightclubber.empty
  haml :index
end

post '/' do
  @clubber = Nightclubber.parse(params)
  if @clubber.save
    subscriber.subscribe @clubber
    session[:subscribed] = true
    redirect to '/done'
  else
    haml :index
  end
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end

get '/nightclubbers' do
  haml :nightclubbers, :locals => {
    :names => nightclubbers_names
  }
end

get '/parties' do
  haml :parties, :locals => {
    :nightclubs => nightclubs
  }
end

get '/about' do
  haml :about
end

get '/reports' do
  erb :reports, :locals => {
    :reports => reports
  }
end

get '/subscribe' do
  subscriber.subscribe_everybody
  'ok'
end

