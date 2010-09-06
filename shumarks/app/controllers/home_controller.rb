# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  before_filter :login_required, :only => [:view_link]
  def index
  end
  
  def about
    @page_title = "About Shumarks"
  end
  
  def addons
    @page_title = "Browser Addons"
  end
  
  def view_link
    if @link = current_user.links.find_by_id(params[:id])
      @link.update_attribute(:is_viewed, true)
      @next_link = current_user.get_next_link()
      
      render 'view_link', :layout => false
    else
      redirect_to user_queue_path
    end
  end
end
