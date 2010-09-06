class LinksController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :destroy, :index]
  
  def new
    @user = current_user
  end

  # Create a link for user currently signed in
  def create
    @user = current_user()
    
    if params[:l]
      parameters = {:url => params[:l], :name => params[:n]}
    else
      parameters = params[:link]
    end
    
    parameters[:is_viewed] = false

    
    @link = @user.links.build(parameters)
    @link.save()
    
    if @link.errors.empty?()
      redirect_to(user_queue_path)
    else
      render(:action => 'new')
    end
  end

  # Delete a link
  def delete
    @link = Link.find(params[:id])
    @link.destroy()
    
    redirect_to(user_queue_path)
  end
end
