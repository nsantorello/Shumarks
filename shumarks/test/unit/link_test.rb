require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  fixtures :all
  # Replace this with your real tests.
  test "should create link" do
    assert_difference 'Link.count' do
      link = create_link
      assert !link.new_record?, "#{link.errors.full_messages.to_sentence}"
      assert users(:alice).links.find_by_id(link.id)
      assert_equal 'Google', link.name
    end
  end
  
  test "check url format" do
    assert_no_difference 'Link.count' do
      link = create_link(:url => 'this is not a valid url')
      assert link.errors.on(:url)
    end
  end
  
  test "should require user_id" do
    assert_no_difference 'Link.count' do
      link = create_link(:user_id => nil)
      assert link.errors.on(:user_id)
    end
  end
  
  test "should require and fix name" do
    assert_difference 'Link.count' do
      link = create_link(:name => nil)
      assert_equal link.url, link.name
    end
  end
  
  test "should require url" do
    assert_no_difference 'Link.count' do
      link = create_link(:url => nil)
      assert link.errors.on(:url)
    end
  end
  
protected
  def create_link(options = {})
    record = Link.new({ :user_id => users(:alice).id, :url => 'http://www.google.com', :name => 'Google', 
      :blurb => 'Blurbiddy blurb'}.merge(options))
    record.save
    record
  end
  
end
