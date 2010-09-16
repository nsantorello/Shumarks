# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
  def create
    self.current_user = User.authenticate(params[:session][:login], params[:session][:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      
      redirect_back_or_default('/')
      
      if !current_user.first_name and !current_user.last_name and ! current_user.bio
        flash[:notice] = "Click on \"Account\" on the top right corner to customize your profile."
      end
    else
      flash[:error] = "Login failed, please try again."
        
      render :partial => 'users/login', :layout => 'application'
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default('/')
  end
end
