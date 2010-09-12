require 'net/http'
class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :edit, :update, :queue, :follow]
  
  # render new.rhtml
  def new
    @page_title = "Shumarks: Signup"
    @header_text = "Sign up"
  end

  # Create new user
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  # Show user
  def show
    @user = current_user
    if @user
      @links = @user.links.find_all().sort_by {|mark| mark.created_at}
	  @links = @links.reverse()
    end
    
    @page_title = "Shumarks: " + @user.login
    @header_text = "#{@user.login}"
  end
  
  # Show user queue
  def queue
    @user = current_user
    if @user
      @links = @user.links.all(:order => 'created_at DESC')
    end
    
    @page_title = "Shumarks: Queue for " + @user.login
    @header_text = "My Shumarks"
  end
  
  # Edit user information
  def edit
    @user = current_user
    if @user
      @links = @user.links.find_all().sort_by {|mark| mark.created_at}
	  @links = @links.reverse()
    end
    
    @page_title = "Shumarks: " + @user.login + " - settings"
    @header_text = "Edit #{@user.login}'s Settings"
  end
  
  # Update user information
  def update
    @user = current_user
    if @user
      @links = @user.links.find_all().sort_by {|mark| mark.created_at}
	  @links = @links.reverse()
    end
    
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password = params[:user][:passord_confirmation]
    if @user.update
      flash[:notice] = "#{@user.login} was successfully updated."
      redirect_to user_queue_path()                               
    else
      render :action => 'edit'
    end
  end
  
  # Follow the user id give. You must be logged in
  def follow    
    @user = User.find_by_id(params[:id])
    current_user.users << @user
    current_user.save()
    
    if current_user.errors.empty?
      flash[:notice] = "You are now following #{@user.login}"
      redirect_to home_path()
    else
      render queue_path(@user.login)
    end
  end
  
  def unfollow
    redirect_to home_path()
  end
  
  # Get salt for remote request
  def remote_get_salt
    @user = login_from_username_and_password
    
    render :text => @user.salt
  end
  
  # Get the queue for remote request
  def remote_get_queue
    @user = login_from_salt
    render :xml => @user.queue_xml 
  end
  
  def remote_create
    @user = login_from_salt
    
    url = params[:url]
    name = params[:name]
    blurb = params[:b]
    if url and name
      @link = @user.links.build({:url => url, :name => name, :is_viewed => false, :blurb => blurb})
      @link.save()
    end
	  redirect_to ("http://localhost:3001/tweet?t=" + URI.escape(name, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) + "&r=" + URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) + "&lid=" + @link.id.to_s + "&uid=" + @user.id.to_s)
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
  
end
