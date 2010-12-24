require 'test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController 
  def rescue_action(e) 
    raise e 
  end
end

class CommentsControllerTest < ActionController::TestCase
  fixtures :all
  
  def setup
    session[:user_id] = users(:alice).id
  end
  
  test "create should create comment" do
    assert_difference "Comment.count" do
      create_comment
    end
  end
  
  test "create should use current user" do
    create_comment
    assert_equal assigns(:comment).user_id, users(:alice).id
  end
  
  test "create should return partial on xhr call" do
    create_comment_xhr
    assert_response 200
  end
  
  test "create should redirect to link page on regular call" do
    create_comment
    assert_redirected_to link_path
  end
  
  test "create requires login" do
    session[:user_id] = nil
    create_comment
    assert_redirected_to access_denied_path
  end
  
  test "create redirects to home page with bad link_id" do
    create_comment(:link_id => 239)
    assert_redirected_to home_path
  end
  
  test "create renders partial on failure" do
    create_comment_xhr(:text => '')
    assert_response 200
  end
  
protected
  def create_comment(options = {})
    post(:create, :comment => {
        :text => 'Blah blah blah, this is the text of comments', 
        :link_id => links(:google).id
      }.merge(options))
  end
  
  def create_comment_xhr(options = {})
    xhr :post, :create, :comment => {
      :text => 'Blah blah blah, this is the text of comments', 
      :link_id => links(:google).id
    }
  end
end