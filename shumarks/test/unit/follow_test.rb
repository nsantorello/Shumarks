require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create follower" do
    assert_difference 'Follow.count' do
      users(:alice).followers << users(:bob)
      assert users(:alice).followers.find(users(:bob))
      assert users(:bob).followees.find(users(:alice))
    end
  end
  
  test "should create followee" do
    assert_difference 'Follow.count' do
      users(:alice).followees << users(:bob)
      assert users(:alice).followees.find(users(:bob))
      assert users(:bob).followers.find(users(:alice))
    end
  end
  
  test "should have created_at" do
    users(:alice).followers << users(:bob)
    assert Follow.find_by_follower_id(users(:bob).id).created_at
  end
end
