class LinksController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :destroy, :index]
  
  # Delete a link
  def delete
    @link = Link.find(params[:id])
    @link.destroy()
    
    redirect_to(my_home_path)
  end
  
  def view
    if not @link = Link.find_by_id(params[:id])
      flash[:error] = "Sorry, the link was not found"
      redirect_to(home_path)
    end
    
    @page_title = @link.name
  end
  
  def redir
    if @link = Link.find_by_id(params[:id])
      if logged_in?
        current_user.read(@link)
      end
      redirect_to("#{@link.url}")    
    else
      redirect_to(home_path)
    end
  end
end
