class LinksController < ApplicationController
  before_filter :login_required, :only => [:delete, :save, :create]
  before_filter :hide_sidebar, :only => []
  
  def save
    @link = current_user.links.build(params[:link])
    @link.save()     
    
    if @link.errors.empty?
      @page_title = 'Success!'
      @post_to_fb = params[:post_fb] != nil
      @post_to_twitter = params[:post_twitter] != nil
      @link_redirect = 'http://shumark.it' + link_redirect_path(@link)
      render 'create_success', :layout => 'bookmarklet_frame'
    else
      @page_title = 'Shumark this page!'
      render 'create', :layout => 'bookmarklet_frame'
    end
  end
  
  def create
    @page_title = 'Shumark this page!'
    @link = Link.new(params[:link])
    render 'create', :layout => 'bookmarklet_frame'
  end
  
  # Delete a link
  def delete
    @link = Link.find(params[:id])
    @adding_from_bookmarklet = params[:bm].blank?
    
    if @link.user == current_user
      @link.destroy()
    end
    
    redirect_to user_path(current_user.login)
  end
  
  def view
    if not @link = Link.find_by_id(params[:id])
      flash[:error] = "Sorry, the link was not found"
      redirect_to(home_path)
    else
      @page_title = "Shumarks: " + @link.name
      @sidebars = [SidebarHelper::RELATED, SidebarHelper::HOT]
      @comments = @link.comments.all(:limit => 10, :order => 'created_at ASC')
    end
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
