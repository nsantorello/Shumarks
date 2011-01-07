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
  
  test "most read links" do
    links(:google).readers << users(:bob)
    links(:google).readers << users(:charlie)
    links(:google).readers << users(:dave)
    links(:google).readers << users(:ellen)
    links(:google).readers << users(:greg) 
    
    links(:microsoft).readers << users(:charlie) 
    links(:microsoft).readers << users(:ellen) 
    links(:microsoft).readers << users(:greg) 
    links(:microsoft).readers << users(:isabelle) 
    
    links(:oracle).readers << users(:dave) 
    links(:oracle).readers << users(:fred) 
    links(:oracle).readers << users(:harry) 
    
    links(:apple).readers << users(:isabelle) 
    links(:apple).readers << users(:jack) 

    links(:yahoo).readers << users(:charlie)
    
    most_read = Link.most_read
    
    assert_equal 5, most_read.length
    
    assert_equal most_read[0], links(:google)
    assert_equal most_read[1], links(:microsoft)
    assert_equal most_read[2], links(:oracle)
    assert_equal most_read[3], links(:apple)
    assert_equal most_read[4], links(:yahoo)
  end
  
  test "most recent links" do
    newly_created = create_link
    most_recent = Link.most_recent
    
    assert_equal 6, most_recent.length
    
    assert_equal most_recent[0], newly_created
    assert_equal most_recent[1], links(:yahoo)
    assert_equal most_recent[2], links(:oracle)
    assert_equal most_recent[3], links(:apple)
    assert_equal most_recent[4], links(:microsoft)
    assert_equal most_recent[5], links(:google)
  end
  
  test "links by followers of" do
    users(:bob).follow(users(:alice))
    users(:bob).follow(users(:charlie))
    
    bobs_feed = Link.feed_of(users(:bob))
    
    assert_equal 3, bobs_feed.length
  end
  
  test "links should have comments" do
    assert links(:google).comments
  end
  
protected
  def create_link(options = {})
    record = Link.new({ :user_id => users(:alice).id, :url => 'http://www.google.com', :name => 'Google', 
      :blurb => 'Blurbiddy blurb'}.merge(options))
    record.save
    record
  end
  
end
