class CommentsController < ApplicationController
  before_filter :login_required, :only => [:create]
  def create
    link_id = params[:comment][:link_id]
    if @link = Link.find_by_id(link_id)
      
      @comment = @link.comments.build
      @comment.text = params[:comment][:text]
      @comment.user_id = current_user.id
      
      @comments = @link.comments
      
      unless @comment.save
        flash[:error] = 'There was a error saving your comment. Please try again.'
      end
    
      if request.xhr?
        render :partial => 'comment', :object => @comment
      else
        redirect_to link_path, :id => @link.id
      end
    else
      redirect_to home_path
    end
  end
  
  def show
    @comments = []
    if @link = Link.find_by_id(params[:link_id])
      if request.xhr?
        @comments = @link.comments.all({:order => 'created_at ASC'}.merge(@pager))
      else
        @comments = @link.comments
      end
    end
    render :partial => 'comments', :object => @comments
  end
  
end