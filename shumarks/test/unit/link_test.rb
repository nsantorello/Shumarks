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
  
  test "should be read_by?" do
    users(:alice).links_read << links(:apple)
    assert links(:apple).read_by?(users(:alice))
  end
  
  test "should get readers who are followers of submitter" do
    users(:bob).follow(users(:alice))
    users(:charlie).follow(users(:alice))
    users(:dave).follow(users(:alice))
    
    links(:google).readers << users(:bob)
    links(:google).readers << users(:charlie)
    links(:google).readers << users(:dave)

    readers = links(:google).readers_who_follow(links(:google).user)
    
    assert_equal 3, readers.length
    users do |user|
      if user.id != users(:alice).id
        assert readers.include?(user)
        readers.delete(user)
      end
    end
  end
  
  test "should get readers who are followers of" do
    users(:bob).follow(users(:charlie))

    links(:google).readers << users(:bob)
    links(:google).readers << users(:charlie)
    links(:google).readers << users(:dave)

    readers = links(:google).readers_who_follow(users(:charlie))
    
    assert_equal 1, readers.length 
    assert readers.include?(users(:bob))
  end
   
  test "number of followers 0 users" do
    assert_equal "", links(:google).num_readers_to_s(users(:charlie))
  end
  
  test "number of followers 1 user" do
    users(:bob).follow(users(:charlie))
    
    links(:google).readers << users(:bob)
    assert_equal "bob read this", links(:google).num_readers_to_s(users(:charlie))
  end
  
  test "number of followers 2 user" do
    users(:bob).follow(users(:charlie))
    users(:dave).follow(users(:charlie))
    
    links(:google).readers << users(:bob)
    links(:google).readers << users(:dave)
    assert_equal "bob and dave read this", links(:google).num_readers_to_s(users(:charlie))
  end
  
  test "number of followers 3 user" do
    users(:bob).follow(users(:charlie))
    users(:dave).follow(users(:charlie))
    users(:ellen).follow(users(:charlie))
 
    links(:google).readers << users(:bob)
    links(:google).readers << users(:dave)
    links(:google).readers << users(:ellen)
    assert_equal "bob, dave and ellen read this", links(:google).num_readers_to_s(users(:charlie))
  end
  
protected
  def create_link(options = {})
    record = Link.new({ :user_id => users(:alice).id, :url => 'http://www.google.com', :name => 'Google', 
      :blurb => 'Blurbiddy blurb'}.merge(options))
    record.save
    record
  end
  
end
