require 'oauth/oauth/consumer'
require 'net/http'
class UsersController < ApplicationController
  before_filter :login_required, :set_user, :only => [:edit, :update, :follow, :unfollow, :follow_list, :follower_list, :home]
  before_filter :hide_sidebar, :only => [:create, :login, :signup, :edit, :update]

  # Create new user
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.find(cookies[:user_id])
    if @user.is_registered
      @user = User.new(params[:user])
    end
    
    @user.is_registered = true
    @user.attributes = params[:user]
    @user.save
    
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
      
      cookies[:user_id] = {:value => @user.id}
      redirect_to user_home_path
    else
      @header_text = 'Create an Account'
      render :partial => 'users/signup', :layout => 'application'
    end
  end
  
  # Log in
  def login
    @page_title = "Login"
    @header_text = "Login"

    render :partial => 'login', :layout => 'application'
  end
  
  # Sign up
  def signup
    @page_title = "Create an Account"
    @header_text = "Create an Account"

    render :partial => 'signup', :layout => 'application'
  end
  
  # Show user queue
  def links
    # Get the user by id
    if params[:id]
      @user = User.find_by_id(params[:id])
    # Get the user by name
    elsif params[:user_name]
      @user = User.find_by_login(params[:user_name])
    end
    
    unless @user
      flash[:error] = "User not found."
      redirect_to(home_path)
    else
      if logged_in?
        if @user.id == current_user.id
          @header_text = "My Shumarks"
          @show_delete = true
        else
          @header_text = "#{@user.login}'s Shumarks"
          @is_following = current_user.following?(@user)
          @show_following = !@is_following
          @show_unfollowing = @is_following
        end
      else
        @header_text = "#{@user.login}'s Shumarks"
      end

      @page_title = "Shumarks: #{@user.login}"
      @sidebars = [SidebarHelper::FRIENDS]
      @links = @user.links.most_recent(@pager)
      @page_total = (@user.links.count.to_f / @page_size.to_f).ceil
    end
  end
  
  def home
    @page_title = "Shumarks: #{@user.login}"
    @header_text = "Recently Shumarked"
    @links = Link.feed_of(current_user, @pager)
    @page_total = (Link.feed_of(current_user, :limit => nil).length.to_f / @page_size.to_f).ceil
  end
  
  # Edit user information
  def edit
    @page_title = "Shumarks: " + @user.login + " - settings"
    @header_text = "Edit #{@user.login}'s Settings"
  end
  
  # Update user information
  def update
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.bio = params[:user][:bio]
    
    if @user.save()
      flash[:notice] = "#{@user.login} was successfully updated."
      redirect_to user_home_path                               
    else
      render :action => 'edit'
    end
  end
  
  # Follow the user give. You must be logged in.
  def follow    
    @user = User.find_by_id(params[:id])
    if @user and current_user.follow(@user)
        flash[:notice] = "You are now following #{@user.login}"
        redirect_to home_path()
    elsif @user
      flash[:notice] = "Already following"
      redirect_to user_path(@user.login)
    else
      redirect_to home_path()
    end
  end
  
  # Unfollow the user given. You must be logged in
  def unfollow
    @user = User.find_by_id(params[:id])
    if @user and current_user.unfollow(@user)
      flash[:notice] = "You are no longer following #{@user.login} :("
      redirect_to home_path()
    elsif @user
      flash[:notice] = "You aren't following #{@user.login}"
      redirect_to user_path(@user.login)
    else
      redirect_to home_path()
    end
  end
  
  def follow_list
    @page_title = 'People you follow'
    @header_text = 'People you follow'
    
    @users = @user.followees
    
    render :partial => '/users/users_list', :layout => 'application'
  end

  def follower_list
    @page_title = 'Your followers'
    @header_text = 'Your followers'
    
    @users = @user.followers
    
    render :partial => '/users/users_list', :layout => 'application'
  end
  
  def search
    @search_term = params[:user_name].gsub('[^a-zA-Z0-9]', '')
    if !@search_term.blank?
      safe_term = "%#{@search_term}%"

      @users = User.all(:conditions => 
          ["login LIKE ? OR first_name LIKE ? OR last_name LIKE ?", safe_term, safe_term, safe_term])
    else
      @users = []
    end

    @page_title = 'Search Results'
    @header_text = "Search results for \"#{@search_term}\""
  
    render :partial => '/users/users_list', :layout => 'application'
  end
    
  # Get salt for remote request
  def remote_get_salt
    @user = login_from_username_and_password
    
    render :text => @user.salt
  end
  
  # Get the queue for remote request
  def remote_get_list
    @user = login_from_salt
    
    render :xml => @user.queue_xml 
  end
  
  def remote_result
    @user = User.find_by_id(params[:uid])
    @link = @user.links.find_by_id(params[:lid])
    if params[:st]
      render 'remote_create_success', :layout => false
    else
      render 'remote_create_fail'
    end 
  end
  
  protected
  def set_user
    @user = current_user
    if @user
      @links = @user.links.most_recent(:limit => @page_size, :offset => @page_size * @page_index)
    end
  end
  
  def self.twitter_consumer
    OAuth::Consumer.new("Wroi8LmryIx1y526fDiDQ", "qRwhATxBcKNedK0pEGm0DeTGrc6kTiHZ9xWEb70Miw",{ :site=>"http://twitter.com" })
  end
  
  public
  def twitter_create
    # Get the user by id
    @user = current_user
    
    if logged_in?
      @request_token = UsersController.twitter_consumer.get_request_token({:oauth_callback => "http://shumark.it/twitter-callback"})
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
      session[:twitter_request_user] = @user.login
      # Send to twitter.com to authorize
      redirect_to @request_token.authorize_url
      return
    else
      flash[:notice] = 'You must be logged in to authenticate with Twitter.'
      redirect_to :action => :home
      return
    end
  end
  
  def twitter_callback
    unless session[:request_token] && session[:request_token_secret] && session[:twitter_request_user]
      flash[:notice] = 'No authentication information was found in the session. Please try again.' 
      redirect_to :action => :home
      return
    end

    unless params[:oauth_token].blank? || session[:request_token] ==  params[:oauth_token]
      flash[:notice] = 'Authentication information does not match session information. Please try again.'
      redirect_to :action => :home
      return
    end

    @request_token = OAuth::RequestToken.new(UsersController.twitter_consumer, session[:request_token], session[:request_token_secret])

    oauth_verifier = params["oauth_verifier"]
    @access_token = @request_token.get_access_token(:oauth_verifier => oauth_verifier)
    
    @twitteruser = TwitterAuth.new({ :screen_name => session[:twitter_request_user],:token => @access_token.token,:secret => @access_token.secret })
    @twitteruser.save!
    
    # The request token has been invalidated
    # so we nullify it in the session.
    session[:request_token] = nil
    session[:request_token_secret] = nil
    session[:twitter_request_user] = nil
    
    # Redirect to the show page
    flash[:notice] = 'Twitter has been authenticated!'
    redirect_to :action => :home
  end
  
  protected 
  def twitter_post
    @user = login_from_salt
    # Make sure status isn't blank and less than 140 chars
    status_update = params[:status]
    # Make sure user has authenticated Twitter.  If they have, retrieve it and enter it below.
    access_token = OAuth::AccessToken.new(UsersController.twitter_consumer, 'access token', 'access secret')
    access_token.post('/statuses/update.json', { :status => status_update_text })
  end
  
  protected
  def facebook_clientid
    "161595543858409"
  end
  
  def facebook_clientsecret
    "d24272f2121e17b1315b9e87733036ed"
  end
  
  def facebook_redirecturi
    "http://shumark.it/facebook-callback"
  end
  
  def facebook_url
    "https://graph.facebook.com"
  end
  
  def facebook_oauthurl
    "/oauth/authorize"
  end
  
  def self.facebook_consumer
    OAuth::Consumer.new(facebook_clientid, facebook_clientsecret, {:site => facebook_url})
  end
  
  public
  def facebook_create
    # Get the user by id
    @user = current_user
    
    if logged_in?
      @request_token = UsersController.twitter_consumer.get_request_token({:oauth_callback => facebook_redirecturi})
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
      session[:facebook_request_user] = @user.login
      # Send to twitter.com to authorize
      redirect_to facebook_url + facebook_oauthurl + "?client_id=" + facebook_clientid + "&redirect_uri=" + facebook_redirecturi + "&scope=publish_stream"
      return
    else
      flash[:notice] = 'You must be logged in to authenticate with Facebook.'
      redirect_to :action => :home
      return
    end
  end
end
