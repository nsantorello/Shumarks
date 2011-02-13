require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :tags
  test "should create tag" do
    assert_difference "Tag.count" do
      tag = create_tag
    end
  end
  
  test "name should be under 20 chars" do
    assert_no_difference "Tag.count" do
      tag = create_tag(:name => 'abcdefghijklmnopqrstuvwxyz')
    end
  end
  
  test "should require name" do
    assert_no_difference "Tag.count" do
      create_tag(:name => nil)
    end
  end
  
  test "should trim white space for name" do
    tag = create_tag(:name => "   abcd\t")
    assert_equal("abcd", tag.name)
  end
  
  test "names should be unique" do
    assert_no_difference "Tag.count" do
      create_tag(:name => tags(:cs).name)
    end
  end
  
  test "create all should do nothing with nil" do
    assert_no_difference "Tag.count" do
      Tag.create_all(nil)
    end
  end
  
  test "create all should create all tags seperated by commas" do
    assert_difference "Tag.count", 3 do
      Tag.create_all('english, history, science')
    end
  end
  
  test "create all returns created tags" do
    tags = Tag.create_all('english')
    assert tags.include?(Tag.find_by_name('english'))
  end
  
  test "create all returns empty when given no tags" do
    tags = Tag.create_all('')
    assert tags.empty?
  end
  
  test "create all returns existing tags" do
    tags = Tag.create_all(tags(:cs).name)
    assert tags.include?(tags(:cs))
  end
  
  test "create all doesn't return nil if fail to create" do
    tags = Tag.create_all('abcdefghijklmnopqrstuvwxyz')
    assert tags.empty?
  end
  
  
  
protected
  def create_tag(options={})
    tag = Tag.new({
      :name => "archeology"
    }.merge(options))
    
    tag.save
    tag
  end
end
