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
  
  test "new user should have salt" do
    get :login
    create_user
    assert assigns(:user).salt
  end
  
  test "new user should not override already registered user" do
    cookies[:user_id] = users(:alice).id
    assert_difference "User.count" do
      create_user
    end
  end
  
  test "should redirect after create" do
    create_user
    assert_redirected_to user_home_path
  end
  
  test "should fail creation and go signup page" do
    create_user(:login => '')
    assert_response 200
  end
  
  test "should render login" do
    get :login
    assert_response 200
    assert_template 'users/_login.html.erb'
  end
  
  test "should render signup" do
    get :signup
    assert_response 200
    assert_template 'users/_signup.html.erb'
  end
  
  test "should render edit" do
    session[:user_id] = users(:alice).id
    get :edit
    assert_response 200
    assert_template 'users/edit.html.erb'
  end
  
  test "should require login to edit" do
    get :edit
    assert_response 302
    assert_redirected_to "/"
  end
  
  test "should require login when update" do
    update_user
    assert_nil assigns(:user)
    assert_response 302
    assert_redirected_to "/"
  end
  
  test "should update" do
    session[:user_id] = users(:alice).id
    update_user
    assert 'zander@ziffler.com', assigns(:user).email
  end
  
  test "should redirect after" do
    session[:user_id] = users(:alice).id
    update_user
    assert_redirected_to user_home_path
  end
  
  test "should not update login" do
    session[:user_id] = users(:alice).id
    update_user
    assert users(:alice).login, assigns(:user).login
  end
  
  test "should follow" do
    session[:user_id] = users(:alice).id
    assert_difference "Follow.count" do
      follow_user(users(:bob))  
    end
    assert users(:alice).following?(users(:bob))
    assert_response 302
  end
  
  test "should require login on follow" do
    assert_no_difference "Follow.count" do
      follow_user(users(:bob))
    end
  end
  
  test "should redirect to sign up page when not logged in" do
    follow_user(users(:bob))
    assert_response 302
  end
  
  test "should don't follow when already following" do
    session[:user_id] = users(:alice).id
    users(:alice).follow(users(:bob))
    assert_no_difference "Follow.count" do
      follow_user(users(:bob))
    end
    assert_response 302
  end
  
  test "should unfollow" do
    session[:user_id] = users(:alice).id
    users(:alice).follow(users(:bob))
    assert_difference "Follow.count", -1 do
      unfollow_user(users(:bob))
    end
    assert_response 302
    assert !users(:alice).following?(users(:bob))
  end
  
  test "should require login when unfollow" do
    users(:alice).follow(users(:bob))
    assert_no_difference "Follow.count" do
      unfollow_user(users(:bob))
    end
    
    assert_response 302
    assert users(:alice).following?(users(:bob))
  end
  
  test "should not unfollow if not following" do
    session[:user_id] = users(:alice).id
    assert_no_difference "Follow.count" do
      unfollow_user(users(:bob))
    end
  end
  
  test "should search for user" do
    search_user('alice')
    assert_response 200
    assert_equal 1, assigns(:users).length
    assert users(:alice), assigns(:users)[0]
    assert_template 'users/_users_list.html.erb'
  end
  
  test "blank search should return no users" do
    search_user('')
    assert_response 200
    assert_equal 0, assigns(:users).length
    assert_template 'users/_users_list.html.erb'
  end
  
  test "should render followers list" do
    session[:user_id] = users(:bob).id
    users(:alice).follow(users(:bob))
    get :follower_list
    assert_response 200
    assert_equal assigns(:users)[0], users(:alice)
    assert_template 'users/_users_list.html.erb'
  end
  
  test "should require login for followers list" do
    get :follower_list
    assert_response 302
  end
  
  test "should render followees list" do
    session[:user_id] = users(:alice).id
    users(:alice).follow(users(:bob))
    get :follow_list
    assert_response 200
    assert_equal assigns(:users)[0], users(:bob)
    assert_template 'users/_users_list.html.erb'
  end
  
  test "should require login for followee list" do
    get :follow_list
    assert_response 302
  end
  
  test "should remote create link" do
    assert_difference "Link.count" do
      remote_create
    end
    assert users(:alice).links.find_by_name('Digg')
  end
  
  test "should require salt for remote create" do
    assert_no_difference "Link.count" do
      remote_create(:s => 'wrongsalt')
    end    
  end
  
  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
    
    def update_user(options = {})
      post :update, :user => { :email => 'zander@ziffler.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
    
    def follow_user(user, options = {})
      get :follow, :id => user.id
    end
    
    def unfollow_user(user, options = {})
      get :unfollow, :id => user.id
    end
    
    def search_user(user_string) 
      get :search, :user_name => user_string
    end
    
    def remote_create(options = {})
      get :remote_create, {:s => users(:alice).salt, 
        :name => 'Digg', 
        :url => 'http://www.digg.com', 
        :blurb => 'Digg Sucks'}.merge(options)
    end
end
