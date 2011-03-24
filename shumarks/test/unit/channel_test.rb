require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  fixtures :all
  
  test "should have name when creating" do
    assert_no_difference 'Channel.count' do
      create_channel(:name => nil)
    end
  end
  
  test "should have user when creating" do
    assert_no_difference 'Channel.count' do
      create_channel(:user_id => nil)
    end
  end
  
  test "should create channel" do
    assert_difference 'Channel.count' do
      create_channel
    end
  end
  
  test "should belong to user" do
      channel = create_channel
      assert_equal(users(:alice), channel.user)
  end
    
  test "channels are unique ignore case on user_id and name" do
    assert_no_difference "Channel.count" do
      create_channel(:user_id => 1, :name => 'tEchNologY')
    end
  end
  
  test "adding link should appear in links" do
    channels(:technology).links << links(:microsoft)
    assert(channels(:technology).links.include?(links(:microsoft)))
  end
  
  test "adding tag should appear in tags" do
    channels(:technology).tags << tags(:cs)
  end
  
protected
  def create_channel(options={})
    channel = Channel.new({
      :user_id => 1,
      :name => 'Funny'
    }.merge(options))
    
    channel.save()
    channel
  end
end
