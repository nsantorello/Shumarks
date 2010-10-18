class LinksController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :delete, :index]
  
  # Delete a link
  def delete
    @link = Link.find(params[:id])
    
    if @link.user = current_user
      @link.destroy()
    end
    
    redirect_to user_path(current_user.login)
  end
  
  def view
    if not @link = Link.find_by_id(params[:id])
      flash[:error] = "Sorry, the link was not found"
      redirect_to(home_path)
    end
    
    @actual_link = true
    @page_title = "Shumarks: " + @link.name
    @hide_sidebar = true
    @header_text = "<a href=\"#{@link.url}\">#{@link.name}</a>"
    
  end
  
  def redir
    if @link = Link.find_by_id(params[:id])
      if logged_in?
        current_user.read(@link)
      else
        user_in_cookie.read(@link)
      end
      redirect_to("#{@link.url}")    
    else
      redirect_to(home_path)
    end
  end
end
