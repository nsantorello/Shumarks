require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    session[:session_id] = Time.now
  end

  test "should should sign up" do
    get :login
    assert user = User.find_by_id(cookies['user_id'])
    assert !(user.login or user.password)
    
    assert_no_difference "User.count" do 
      create_user
      assert assigns(:user)

      assert_equal 'quire', internal_session.user.login
    end
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
