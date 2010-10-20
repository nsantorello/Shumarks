require 'test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    session[:session_id] = Time.now
  end
  
  test "should create unregistered user when hit a page" do
    assert_difference "User.count" do
      get :login
      assert user = internal_session.user
      assert !user.is_registered
    end
  end
  
  test "should not create new user when registering" do
    get :login
    assert_no_difference "User.count" do
      create_user
    end
  end

  test "new user should have same id as in internal session" do
    get :login
    user = internal_session.user
    create_user
    assert user.id == assigns(:user).id
  end
  
  test "new user should not override already registered user" do
    cookies[:user_id] = users(:alice).id
    assert_difference "User.count" do
      create_user
    end
  end
  
  test "new user should be saved in cookie" do
    create_user
    assert_equal assigns(:user).id, cookies[:user_id]
  end
  
  test "should have salt after create unregistered" do
    create_user(:is_registered => false, :login => nil)
    assert assigns(:user).salt
  end
  
  test "should redirect after create" do
    create_user
    assert_redirected_to user_home_path
  end
  
  test "should fail creation and go signup page" do
    create_user(:login => '')
    assert_response 200
  end
  
  
  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
