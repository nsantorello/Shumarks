require 'test_helper'
require 'bookmarklet_controller'

# Re-raise errors caught by the controller.
class BookmarkletController 
  def rescue_action(e) 
    raise e 
  end
end

class BookmarkletControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    session[:session_id] = Time.now
  end
  
  test "should show logged out replace bookmarklet page" do
    get :old_bookmarklet_landing
    assert_template 'bookmarklet/replace_old_bookmarklet_logged_out.html.erb'
  end
  
  test "should show logged in replace bookmarklet page" do
    get :old_bookmarklet_landing, :s => users(:alice).salt
    assert_template 'bookmarklet/replace_old_bookmarklet_logged_in.html.erb'
  end
  
  
  
end