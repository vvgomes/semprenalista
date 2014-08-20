class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def index
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate!
    current_user || redirect_to((request.env['HTTP_REFERER'].blank?) ? root_path : :back, :notice => 'You need to be logged in!')
  end
end
