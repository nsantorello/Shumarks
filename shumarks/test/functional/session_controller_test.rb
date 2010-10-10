require 'test_helper'

class SessionControllerTest < ActionController::TestCase

  fixtures :users
  
  def setup
    session[:session_id] = Time.now
  end
  
  test "should login" do
    cookies[:user_id] = { :value => User.new(:is_registered => false).save().id }
    logged_out_user_id = cookies[:user_id].to_i
    post :create, :session => {:login => users(:alice).login, :password => 'test' }
    
    assert_equal "Click on \"Account\" on the top right corner to customize your profile.", flash[:notice]
    assert_equal users(:alice).id, session[:user_id]
    assert_equal users(:alice).id, internal_session.user.id
    assert_equal logged_out_user_id, cookies[:user_id].to_i
  end
  
  test "should logout" do
    int_session = Session.new(:ruby_session_id => session[:session_id], :user_id => users(:alice).id)
    int_session.save
    
    session[:user_id] = users(:alice).id
    session[:internal_session_id] = int_session.id
    
    post :destroy
    
    assert Session.find_by_id(int_session.id).destroyed_at
    assert_nil cookies[:auth_token]
  end

end
