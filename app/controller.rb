require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

configure do
  enable :sessions
  set :app_file, __FILE__
  set :views, File.dirname(__FILE__)+'/views'
  set :public_folder, File.dirname(__FILE__)+'/../public'
end

helpers do
  def load_clubber email
    Nightclubber.where(:email => email).first
  end

  def feedback_after operation 
    { :create => '<strong>Feito!</strong> Voce está em todas as listas para sempre :)',
      :update => 'Inscrição alterada com sucesso.',
      :delete => 'Inscrição removida com sucesso.'
    }[operation]
  end
end

get '/' do
  @clubber = Nightclubber.empty
  haml :index
end

post '/' do
  @clubber = Nightclubber.parse(params)
  if @clubber.save
    flash[:notice] = feedback_after :create
    redirect to '/'
  else
    haml :index 
  end
end

put '/' do
  @clubber = load_clubber params[:email]
  @clubber.parse params
  if @clubber.save
    flash[:notice] = feedback_after :update
    redirect to '/'
  else
    haml :index  
  end
end

delete '/' do
  @clubber = load_clubber params[:email]
  @clubber.delete
  flash[:notice] = feedback_after :delete
  redirect to '/'
end

get '/search' do
  content_type :json
  @clubber = load_clubber params[:email]
  @clubber.to_json
end

get '/parties' do
  haml :parties, :locals => { :nightclubs => Nightclub.all }
end

get '/about' do
  haml :about
end
