require "net/http"
require "uri"

class LinksController < ApplicationController
  before_filter :login_required, :only => [:delete, :save, :create]
  before_filter :hide_sidebar, :only => []
  
  def post_url_to_facebook(fb_post_params, link)
    fb_params = fb_post_params.split('&')
    user_id = fb_params[0]
    access_token = fb_params[1]
    
    # Make post to FB
    uri = URI.parse(URI.encode("https://graph.facebook.com/" + user_id + "/feed"))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"access_token" => access_token, "link" => link.url, "name" => link.name, "caption" => link.short_url, "description" => link.blurb})
    response = http.request(request)
  end
  
  def save
    @link = current_user.links.build(params[:link])
    @link.save()     
    
    # Post to FB if the user wishes
    if (params[:post_fb] != nil)
      post_url_to_facebook(params[:post_fb], @link)
    end
    
    if @link.errors.empty?
      @page_title = 'Success!'
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
