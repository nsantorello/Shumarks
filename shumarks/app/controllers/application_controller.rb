# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # for SSL use
  include SslRequirement
  
  before_filter :set_timezone

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # reset title to default
  before_filter :save_session, :login_from_salt, :set_common_vars
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def set_timezone
    Time.zone = browser_timezone
  end
    
  def browser_timezone
    if cookies[:tz].blank?
      return 0.minutes
    else
      -cookies[:tz].to_i.minutes
    end
  end
  
  def local_time(time)
    time.in_time_zone(browser_timezone)
  end
  
protected
  def set_common_vars
    @page_title = "Shumarks"
    @page_index = params[:p] ? params[:p].to_i - 1 : 0
    @page_size = 10
    @page_total = 0
  end
  
  def save_session
    # First request to the server, start the session
    if not internal_session = Session.find_by_ruby_session_id(session[:session_id])
      internal_session = Session.new(
        :ruby_session_id => session[:session_id], 
        :referrer => request.referrer,
        :user_agent => request.env['HTTP_USER_AGENT'],
        :client_ip => request.remote_ip
      )
      internal_session.save()
      
      # First time user
      if not cookies[:user_id]
        user = User.new(:is_registered => false)
        user.save
        cookies[:user_id] = {:value => user.id, :expires => 1.months.from_now}

        internal_session.update_attributes(:user_id => cookies[:user_id].to_i)
      end      
    end
    
    session[:internal_session_id] = internal_session.id
  end  

end
