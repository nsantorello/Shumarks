# This controller handles the tutorial that you go through after registering.
class TutorialController < ApplicationController
  before_filter :login_required
  before_filter :hide_sidebar
  
  def index
    @header_text = "Shumarked!"
    @most_recent = Link.most_recent(@pager)
    @page_total = (Link.count.to_f / @page_size.to_f).ceil
    @show_welcome = !logged_in?
  end
  
  def about
    @page_title = "About Shumarks"
    @header_text = "Shumarks"
  end
end
