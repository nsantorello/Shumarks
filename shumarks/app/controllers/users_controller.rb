require 'net/http'
class UsersController < ApplicationController
  before_filter :login_required, :set_user, :only => [:edit, :update, :follow, :unfollow, :follow_list, :follower_list]

  # Create new user
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.find(cookies[:user_id])
    @user.is_registered = true
    @user.update_attributes(params[:user])
    
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
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
  def home
    # Get the user by id
    if params[:id]
      @user = User.find_by_id(params[:id])
    # Get the user by name
    elsif params[:user_name]
      @user = User.find_by_login(params[:user_name])
    end
    
    if logged_in?
      if @user
        if @user.id == current_user.id
          @header_text = "My Shumarks"
          @is_self = true
        else
          @header_text = "#{@user.login}'s Shumarks"
          @is_following = current_user.following?(@user)
        end
      else
        @user = current_user
        @header_text = "My Shumarks"
        @is_self = true
      end
    else
      if @user
        @header_text = "#{@user.login}'s Shumarks"
      else
        redirect_to(home_path)
        return
      end
    end

    @page_title = "Shumarks: #{@user.login}"
    @links = @user.links.all(:order => 'created_at DESC')
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
      redirect_to my_home_path()                               
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
      redirect_to  user_home_path(@user.login)
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
      redirect_to  user_home_path(@user.login)
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
    safe_term = "%#{@search_term}%"
    print safe_term
    @users = User.all(:conditions => 
        ["login LIKE ? OR first_name LIKE ? OR last_name LIKE ?", safe_term, safe_term, safe_term])
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
  
  def remote_create
    @user = login_from_salt
    
    url = params[:url]
    name = params[:name]
    blurb = params[:b]
    if url and name
      @link = @user.links.build({:url => url, :name => name, :blurb => blurb})
      @link.save()
    end
    if @link.errors.empty?
      render 'remote_create_success', :layout => false
    else
      render 'remote_create_fail'
    end
	  #redirect_to ("http://localhost:3001/tweet?t=" + URI.escape(name, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) + "&r=" + URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) + "&lid=" + @link.id.to_s + "&uid=" + @user.id.to_s)
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
      @links = @user.links.all(:order => 'created_at DESC')
    end
  end
  
end
