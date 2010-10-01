# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  def index
    if logged_in?
      #following_user_ids = current_user.followees.all(:include => links).map(&:follow_id)
      @links = Link.all(:conditions => {:user_id => current_user.followee_ids}, :order => 'created_at DESC')
      
      @header_text = "Your friends' Shumarks"
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
end
