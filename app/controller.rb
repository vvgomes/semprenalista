require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

configure do
  enable :sessions
  set :app_file, __FILE__
  set :public_folder, File.dirname(__FILE__)+'/../public'
  set :views, File.dirname(__FILE__)+'/views'
end

get '/' do
  @clubber = Nightclubber.empty
  haml :index
end

post '/' do
  @clubber = Nightclubber.parse(params)
  if @clubber.save
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
    :names => Nightclubber.sorted_names
  }
end

get '/parties' do
  haml :parties, :locals => {
    :nightclubs => Nightclub.all
  }
end

get '/about' do
  haml :about
end

get '/subscriptions' do
  erb :subscriptions, :locals => {
    :subscriptions => Nightclubber.all_subscriptions,
    :missing => Nightclubber.all_missing_from Party.all
  }
end
