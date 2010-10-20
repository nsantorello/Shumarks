require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  
  fixtures :all
  
  def setup
    session[:session_id] = Time.now
  end
  
  test "should view link" do
    get :view, :id => links(:google).id
    assert_response 200
    assert assigns :link
  end
  
  test "should not view non-existant link" do
    get :view, :id => 0
    assert_redirected_to home_path
  end
  
  test "should redir to link url" do
    get :redir, :id => links(:google).id
    assert_redirected_to links(:google).url
  end
  
  test "should not redir unknown link" do
    get :redir, :id => 0
    assert_redirected_to home_path
  end
  
  test "should not mark read when redir to unknown" do
    assert_no_difference "ReadReceipt.count" do
      get :redir, :id => 0
    end
  end
  
  test "should anonymous read when redir" do
    get :redir, :id => links(:google).id
    assert links(:google).readers[0].id == internal_session[:user_id]
  end
  
  test "should read when redir logged in" do
    session[:user_id] = users(:bob).id
    get :redir, :id => links(:google).id
    assert links(:google).readers[0].id == users(:bob).id
  end
  
  test "should not delete if not logged in" do
    assert_no_difference "Link.count" do
      post :delete, :id => links(:google).id
    end
  end
  
  test "should not delete if user didn't submit link" do
    session[:user_id] = users(:bob)
    assert_no_difference "Link.count" do
      post :delete, :id => links(:google).id
    end
  end
  
  test "should redirect if logged in" do
    session[:user_id] = users(:bob)
    post :delete, :id => links(:google).id
    assert_redirected_to user_path(users(:bob).login)
  end
  
  test "should delete" do
    session[:user_id] = users(:alice)
    assert_difference "Link.count", -1 do
      post :delete, :id => links(:google).id
    end
  end
  
end
