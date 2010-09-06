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
  before_filter :reset_title
  
  # log user in if salt was passed in
  before_filter :login_from_salt
  
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
  def reset_title
    @page_title = "Shumarks"
  end  

end
