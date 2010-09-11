# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  def index
  end
  
  def about
    @page_title = "About Shumarks"
  end
  
  def addons
    @page_title = "Browser Addons"
  end
  
  def queue
    @user = User.find_by_id(params[:id])
    @links = @user.links.find_all()
    @page_title = "#{@user.login}"
  end
  
  def view_link
    if @link = Link.find_by_id(params[:id])
      @link.update_attribute(:is_viewed, true)
      @user = User.find_by_id(@link.user_id)
      @next_link = @user.get_next_link()
      
      render 'view_link', :layout => false
    else
      redirect_to user_queue_path
    end
  end
end
