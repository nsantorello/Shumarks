# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  def index
    if logged_in?
      following_user_ids = current_user.users.all(:select => 'follow_id').map(&:follow_id)
      
      @links = Link.all(:conditions => {:user_id => following_user_ids}, :order => 'created_at DESC')
      
      @header_text = "You're friends Shumarks"
      render "index_loggedin"
    else
      @header_text = "Welcome to Shumarks"
      render "index_loggedout"
    end
  end
  
  def about
    @page_title = "About Shumarks"
    @header_text = "Shumarks"
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
    @header_text = "#{@user.login}'s Shumarks"
  end
  
  def view_link
    if @link = Link.find_by_id(params[:id])
      @link.update_attribute(:is_viewed, true)
      @user = User.find_by_id(@link.user_id)
      @next_link = @user.get_next_link()
      
      redirect_to "#{@link.url}"
    else
      flash[:error] = "Sorry, the link was not found"
      redirect_to home_path
    end
  end
end
