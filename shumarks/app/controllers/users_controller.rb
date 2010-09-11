class UsersController < ApplicationController
  before_filter :login_required, :set_user, :only => [:show, :edit, :update, :queue]
  
  # render new.rhtml
  def new
    @page_title = "Shumarks: Signup"
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
    @page_title = "Shumarks: " + @user.login
  end
  
  # Show user queue
  def queue
    @page_title = "Shumarks: Queue for " + @user.login
  end
  
  # Edit user information
  def edit
    @page_title = "Shumarks: " + @user.login + " - settings"
  end
  
  # Update user information
  def update
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password = params[:user][:passord_confirmation]
    if @user.update
      flash[:notice] = 'User was successfully updated.'
      redirect_to user_queue_path                               
    else
      render :action => 'edit'
    end
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
    if url and name
      @link = @user.links.build({:url => url, :name => name, :is_viewed => false})
      @link.save()
    end
      
    if @link.errors.empty?()
      render :text => 'Success'
    else
      render :text => "Failed"
    end
  end
  
  protected
  def set_user
    @user = current_user
    if @user
      @links = @user.links.find_all
    end
  end
  
end
