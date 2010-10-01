require 'test_helper'

class ReadReceiptTest < ActiveSupport::TestCase
  
  fixtures :all
  # Replace this with your real tests.
  test "should create" do
    assert_difference 'ReadReceipt.count' do
      users(:alice).links_read << links(:apple)
      assert users(:alice).links_read.find(links(:apple).id)
      assert links(:apple).readers.find(users(:alice).id)
    end
  end
  
  test "should have created_date" do
    users(:alice).links_read << links(:apple)
    ReadReceipt.find_by_user_id(users(:alice).id).created_at
  end
end
