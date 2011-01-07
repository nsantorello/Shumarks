require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :all

  # test able to create users
  test "should create user" do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?
    end
  end
  
  test "new registered users should have salt" do
    assert create_user.salt
  end
  
  test "new unregistered users don't have salf" do
    assert !create_user(:is_registered => false).salt
  end
  
  test "should create non-registered user" do
    assert_difference 'User.count' do
      user = create_user(:is_registered => false)
      assert !user.new_record?
    end
  end
  
  test "should require is_registered" do
    assert_no_difference 'User.count' do
      user = create_user(:is_registered => nil)
      assert user.errors.on(:is_registered)
    end
  end

  # test login is required
  test "should require login" do
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  # test login should be unique case insensitive
  test "check unique login" do
    assert_no_difference 'User.count' do
      u = create_user(:login => 'BoB')
      assert u.errors.on(:login)
    end
  end
  
  # test email should be unique case insensitive
  test "check unique email" do
    assert_no_difference 'User.count' do
      u = create_user(:email => 'AlIcE@gMaIl.CoM')
      assert u.errors.on(:email)
    end
  end

  # test password required
  test "should require password" do
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  # test password confirmation required
  test "should require password confirmation" do
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  # test email is required
  test "should require email" do
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  # test check login format to only include alpha-numeric, - and _ characters
  test "check login format" do
    assert_no_difference 'User.count' do
      u = create_user(:login => 'hello asdf ,3 a0 32')
      assert u.errors.on(:login)
    end
  end
  
  # test check email format
  test "check email format" do
    assert_no_difference 'User.count' do
      u = create_user(:email => '234@ asdf.com')
      assert u.errors.on(:email)
    end
  end
  
  # test should follow another user
  test "should follow" do
    assert_difference 'users(:alice).followees.count' do
      users(:alice).follow(users(:bob))
      assert users(:alice).followees.find_by_id(users(:bob).id)
      assert users(:bob).followers.find_by_id(users(:alice).id)
    end
  end
  
  # test should not be able to follow self
  test "should not follow self" do
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).follow(users(:alice))
    end
  end
  
  # test should not be able to follow someone twice
  test "should follow unique" do
    users(:alice).follow(users(:bob))
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).follow(users(:bob))
    end
  end
  
  test "should unfollow" do
    users(:alice).follow(users(:bob))
    assert_difference 'users(:alice).followees.count', -1 do
      users(:alice).unfollow(users(:bob))
    end
  end
  
  test "should not unfollow when not following" do
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).unfollow(users(:bob))
    end
  end
  
  test "should not unfollow self" do
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).unfollow(users(:alice))
    end
  end
  
  test "should not follow un-registered" do
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).follow(users(:fred))
    end
  end
  
  test "cannot follow when un-registered" do
    assert_no_difference 'users(:fred).followees.count' do
      users(:fred).follow(users(:alice))
    end
  end
  
  test "should require followee" do
    assert_no_difference 'users(:alice).followees.count' do
      users(:alice).follow(nil)
    end
  end
  
  test "should be following?" do
    assert !users(:alice).following?(users(:bob))
    users(:alice).follow(users(:bob))
    assert users(:alice).following?(users(:bob))
  end
  
  test "should be followed by?" do
    assert !users(:bob).followed_by?(users(:alice))
    users(:alice).follow(users(:bob))
    assert users(:bob).followed_by?(users(:alice))
  end
  
  test "home url" do
    assert_equal "#{ENV['hostname']}/alice", users(:alice).home_page_url
  end
  
  test "should read" do
    assert_difference 'ReadReceipt.count' do
      assert users(:bob).read(links(:google))
    end
  end
  
  test "should not read again" do
    users(:bob).read(links(:google))
    assert_no_difference 'ReadReceipt.count' do
      assert !users(:bob).read(links(:google))
    end
  end
  
  test "should not read self" do
    users(:alice).read(links(:google))
    assert_no_difference 'ReadReceipt.count' do
      assert !users(:alice).read(links(:google))
    end
  end
  
  test "should have read" do
    assert !users(:bob).has_read?(links(:google))
    assert users(:bob).read(links(:google))
    assert users(:bob).has_read?(links(:google))
  end
  
  test "should read when un-registered" do
    assert_difference 'ReadReceipt.count' do
      assert users(:fred).read(links(:google))
    end
  end

  test "should reset password" do
    users(:alice).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:alice), User.authenticate('alice', 'new password')
  end

  test "should not rehash password" do
    users(:alice).update_attributes(:login => 'alice2')
    assert_equal users(:alice), User.authenticate('alice2', 'test')
  end

  test "should authenticate user" do
    assert_equal users(:alice), User.authenticate('alice', 'test')
  end

  test "should set remember token" do
    users(:alice).remember_me
    assert_not_nil users(:alice).remember_token
    assert_not_nil users(:alice).remember_token_expires_at
  end

  test "should unset remember token" do
    users(:alice).remember_me
    assert_not_nil users(:alice).remember_token
    users(:alice).forget_me
    assert_nil users(:alice).remember_token
  end

  test "should remember me for one week" do
    before = 1.week.from_now.utc
    users(:alice).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:alice).remember_token
    assert_not_nil users(:alice).remember_token_expires_at
    assert users(:alice).remember_token_expires_at.between?(before, after)
  end

  test "should remember me until one week" do
    time = 1.week.from_now.utc
    users(:alice).remember_me_until time
    assert_not_nil users(:alice).remember_token
    assert_not_nil users(:alice).remember_token_expires_at
    assert_equal users(:alice).remember_token_expires_at, time
  end

  test "should remember me default two weeks" do
    before = 2.weeks.from_now.utc
    users(:alice).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:alice).remember_token
    assert_not_nil users(:alice).remember_token_expires_at
    assert users(:alice).remember_token_expires_at.between?(before, after)
  end


protected
  def create_user(options={})
    record = User.new({ 
        :login => 'quire', 
        :email => 'quire@example.com', 
        :password => 'quire', 
        :password_confirmation => 'quire',
        :is_registered => true
      }.merge(options))
      
    record.save
    record
  end
end
