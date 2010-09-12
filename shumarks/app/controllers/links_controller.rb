class LinksController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :destroy, :index]
  
  # Delete a link
  def delete
    @link = Link.find(params[:id])
    @link.destroy()
    
    redirect_to(user_queue_path)
  end
end
