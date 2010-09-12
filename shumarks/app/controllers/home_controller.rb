# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  def index
    if logged_in?
      @links = Link.all(['user_id in ?', current_user.user_ids], :order => 'created_at DESC');
      render "index_loggedin"
    else
      render "index_loggedout"
    end
  end
  
  def about
    @page_title = "About Shumarks"
  end
  
  def addons
    @page_title = "Browser Addons"
  end
  
  def queue
    
    if params[:id]
      @user = User.find_by_id(params[:id])
    elsif params[:user_name]
      @user = User.find_by_login(params[:user_name])
    else
      redirect_to home_path
      return
    end
    
    if logged_in? and @user and @user.id == current_user.id
      redirect_to user_queue_path
      return
    end
    
    @links = @user.links.find_all().sort_by {|mark| mark.created_at}
	  @links = @links.reverse()
	
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
