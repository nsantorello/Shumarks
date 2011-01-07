# This controller handles the login/logout function of the site.  
class HomeController < ApplicationController
  before_filter :hide_sidebar, :only => [:about, :addons]
  
  def index
    @header_text = logged_in? ? "Most Recent" : "Shumarks"
    
    @most_recent = Link.most_recent(@pager)
    @page_total = (Link.count.to_f / @page_size.to_f).ceil
    @show_welcome = !logged_in?
  end
  
  def about
    @page_title = "About Shumarks"
    @header_text = "Shumarks"
  end
end
