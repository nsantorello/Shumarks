require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  test "create should require use_id" do
    assert_no_difference "Comment.count" do
      create_comment(:user_id => nil)
    end
  end
  
  test "create should require link_id" do 
    assert_no_difference "Comment.count" do
      create_comment(:link_id => nil)
    end
  end
  
  test "create should check text max length" do
    assert_no_difference "Comment.count" do
      create_comment(:text => 'abcdefjhij' * 101);
    end
  end
  
  test "create should check text min length" do
    assert_no_difference "Comment.count" do
      create_comment(:text => '');
    end
  end
  
  test "create should create comment" do
    assert_difference "Comment.count" do
      create_comment();
    end
  end

  
protected
  def create_comment(options = {})
    record = Comment.new({ 
        :text => 'Blah blah blah, this is the text of comments', 
        :user_id => 1, 
        :link_id => 1, 
      }.merge(options))
      
    record.save
    record
  end
end
