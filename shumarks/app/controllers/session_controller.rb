# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
  before_filter :hide_sidebar, :only => [:create]
  # Login
  def create
    if (params[:session]) 
      self.current_user = User.authenticate(params[:session][:login], params[:session][:password])
    
      if logged_in?
        if params[:remember_me] == "1"
          unless current_user.remember_token?
            current_user.remember_me 
          end
        
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
      
        if !current_user.first_name and !current_user.last_name and ! current_user.bio
          flash[:notice] = "Click on \"Account\" on the top right corner to customize your profile."
        end
      
        redirect_back_or_default(user_home_path)
      else
        flash[:error] = "Login failed, please try again."
        
        redirect_to login_path 
      #  render :partial => 'users/login', :layout => 'application'
      end
    else
      flash[:error] = "Login failed, please try again."
      redirect_to login_path 
      #render :partial => 'users/login', :layout => 'application'
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
