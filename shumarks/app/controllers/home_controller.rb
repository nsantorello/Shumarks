# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  def index
    @header_text = logged_in? ? "Most Recent" : "Shumarks"
    
    @most_recent = Link.most_recent(:limit => @page_size, :offset => @page_size * @page_index)
    @page_total = Link.count / @page_size
    @most_read = Link.most_read
    @show_welcome = !logged_in?
  end
  
  def about
    @page_title = "About Shumarks"
    @header_text = "Shumarks"
  end
  
  def addons
    @page_title = "Browser Addons"
  end
end
