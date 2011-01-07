class BookmarkletController < ApplicationController
  before_filter :hide_sidebar, :only => [:old_bookmarklet_landing]
  
  layout 'application', :except => :remote_bookmarklet_javascript
  
  def remote_bookmarklet_javascript
    @salt = params[:salt]
    render :file => 'bookmarklet/remote_bookmarklet.js.erb', :content_type => 'text/javascript'
  end
  
  def old_bookmarklet_landing
    login_from_salt
    
    if current_user
      @header_text = 'Get the new and improved Shumarklet!'
      render 'replace_old_bookmarklet_logged_in'
    else
      @header_text = 'Your Shumarklet has an error.'
      render 'replace_old_bookmarklet_logged_out'
    end
  end
  
end