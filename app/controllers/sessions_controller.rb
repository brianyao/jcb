class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user

  def failure
  end

  def create
    # reset_session
    auth = request.env['omniauth.auth']
    # render :text => auth.inspect
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
      User.create_with_omniauth(auth)
    session[:uid] = user.uid
    redirect_to words_path
  end
  
  def destroy
    # reset_session
    session.delete(:uid)
    flash[:notice] = 'Logged out successfully.'
    redirect_to words_path
  end
end
