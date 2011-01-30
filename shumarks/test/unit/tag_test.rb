require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "should require name" do
    assert_no_difference "Tag.count" do
      create_tag(:name => nil)
    end
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
