require 'rubygems'
require 'bundler'

Bundler.require :default

set :app_file, __FILE__
set :views, File.dirname(__FILE__) + '/views'
enable :sessions

#startup:
# @subscriber = Subscriber.new
# @subscriber.add_party_place = Cabaret.new
# @subscriber.add_party_place = Beco.new
# rufus tell @subscriber.subscribe_everybody

get '/' do
  haml  :index
end

post '/subscribe' do
  session[:subscribed] = true
  
  #raver = Nightclubber.new params[:name], params[:email]
  #params[:friends].values.each do |friend|
  #  raver.take friend
  #end
  
  #@subscriber.subscribe raver
  #@subscriber.add raver
  
  redirect to '/done'
end

get '/done' do
  redirect to '/' if !session[:subscribed]
  session[:subscribed] = false
  haml :done
end

post '/test' do
  #log something
  redirect to '/'
end