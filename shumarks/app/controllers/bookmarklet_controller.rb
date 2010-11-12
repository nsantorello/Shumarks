class BookmarkletController < ApplicationController
  layout nil
  
  def remote_bookmarklet_javascript
    @salt = params[:salt]
    render :file => 'bookmarklet/remote_bookmarklet.js.erb', :content_type => 'text/javascript'
  end
end