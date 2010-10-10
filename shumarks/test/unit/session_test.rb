require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
  fixtures :all
  
  test "should create" do
    assert_difference 'Session.count' do
      create_session()
    end
  end
  
  test "should require ruby_session_id" do
    assert_no_difference 'Session.count' do
      session = create_session(:ruby_session_id => nil)
      assert session.errors.on(:ruby_session_id)
    end
  end
  
  
protected
  def create_session(options={})
    session = Session.new({:ruby_session_id => "3b3983e3890e0f8870c0980a70b8934", 
                 :user_id => 1, 
                 :referrer => "http://www.google.com",
                 :user_agent => 'Mozilla/7.0 (Windows; U; Windows NT 7.0; fr; rv:2.5.7.10) Gecko/201460 Firefox/4.0.4',
                 :client_ip => "192.168.1.1"}.merge(options))
    session.save()
    session
  end
end