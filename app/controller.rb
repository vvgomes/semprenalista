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
  redirect to '/' unless session[:subscribed]
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
    :missing => Nightclubber.missing_emails_with_party_urls(Party.all)
  }
end

post '/search' do
  content_type :json
  clubber = Nightclubber.find_by(params[:email])
  clubber.to_json # "null" for not found
end

put '/' do
  @clubber = Nightclubber.find_by(params[])
  if @clubber.save
    session[:subscribed] = true
    redirect to '/done'
  else
    haml :index
  end
end
