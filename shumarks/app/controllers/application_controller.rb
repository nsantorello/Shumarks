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
  before_filter :save_session, :set_common_vars
  
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
    @page_max = 10
    @page_total = 0
    @page_offset = [@page_index - @page_max/2, 0].max
    @pager = { :limit => @page_size, :offset => @page_size * @page_index }
    @most_read = Link.most_read
  end
  
  def save_session
    # First request to the server, start the session
    user_agent = request.env['HTTP_USER_AGENT']
    unless user_agent =~ /bot|baidu/
      # First time user
      unless cookies[:user_id] or logged_in?
        user = User.new(:is_registered => false)
        user.save
      else
        user = User.find_by_id(cookies[:user_id].to_i) || current_user
      end
      
      internal_session.update_attributes(:user_id => user.id)
      cookies[:user_id] = {:value => user.id, :expires => 1.months.from_now}
    end
  end  
end
