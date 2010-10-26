# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
  # Login
  def create
    self.current_user = User.authenticate(params[:session][:login], params[:session][:password])
    
    if logged_in?
      if params[:remember_me] == "1"
        unless current_user.remember_token?
          current_user.remember_me 
        end
        
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        cookies[:user_id] = {:value => current.id}
      end
      
      redirect_back_or_default(user_home_path)
      
      if !current_user.first_name and !current_user.last_name and ! current_user.bio
        flash[:notice] = "Click on \"Account\" on the top right corner to customize your profile."
      end
      
    else
      flash[:error] = "Login failed, please try again."
      @hide_sidebar = true
        
      render :partial => 'users/login', :layout => 'application'
    end
  end
  
  # Log out
  def destroy
    if logged_in?
      self.current_user.forget_me
    end
    cookies.delete :auth_token
    internal_session.update_attributes(:destroyed_at => Time.now)
    
    reset_session

    redirect_back_or_default('/')
  end
end
