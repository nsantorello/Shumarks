require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  def setup
    session[:session_id] = Time.now
  end
  
  test "should create session" do
    assert_difference "Session.count" do
      get :index
      assert_response 200
      assert internal_session = Session.find_by_id(session[:internal_session_id])
      assert internal_session.user_id = cookies['user_id']
    end
  end
  
  test "should not create session for spiders" do
    assert_no_difference "Session.count" do
      @request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
      get :index
      assert_response 200
      assert_nil internal_session = Session.find_by_id(session[:internal_session_id])
    end
  end
end
