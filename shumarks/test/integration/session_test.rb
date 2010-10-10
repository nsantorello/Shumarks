require 'test_helper'


class SessionTest < ActionController::IntegrationTest
  fixtures :all
  
  test "should create session" do
    assert_difference "Session.count" do
      get "/"
      assert_response 200
      assert internal_session = internal_session
      assert internal_session.user_id = cookies['user_id']
    end
  end
end