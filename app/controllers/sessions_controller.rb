class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'User logged out.'
  end

  def failure
    redirect_to root_url, :alert => 'Could not authenticate, sorry.'
  end
end
