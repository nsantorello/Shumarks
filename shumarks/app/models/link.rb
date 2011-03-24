include ActionView::Helpers::TextHelper
class Link < ActiveRecord::Base
	belongs_to :user
  belongs_to :channel
	validates_presence_of :url, :user_id, :name
	validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?.*$/ix
	
	before_validation :fix_url, :fix_name
	
  has_many :read_receipts
	has_many :readers, :through => :read_receipts, :source => :reader
  has_many :comments
  has_and_belongs_to_many :tags
  
  attr_accessor :tags_to_add
	
	# If the url doesn't have http:// or https://, add it
	def fix_url
	  if self.url and not self.url.match(/^(http|https):\/\/.*/)
	    self.url = 'http://' + self.url
    end
	end
	
	# If the name is ever empty, populate it with the url
	def fix_name
	  if not self.name
	    self.name = self.url
    end
	end
	
	def short_url(how_short = 30)
	  str = self.url
		shortlink = (str.length > how_short) ? (str[0..how_short] + "...") : str
		return shortlink
	end
	
	# Shortens a description
	def short_blurb(how_short = 200)
		str = self.blurb
		shortblurb = (str.length > how_short) ? (str[0..how_short] + "...") : str
		return shortblurb
	end
	
	# Shortens a name to only 60 characters
	def short_name(how_short = 55)
		str = self.name
		shortname = (str.length > how_short) ? (str[0..how_short] + "...") : str
		return shortname
	end
	
	# Checking to see if user given has read this link
	def read_by?(user)
	  user and self.readers.find_by_id(user.id)
  end
  
  # Get the readers of this link who follow the given user
  def readers_who_follow(user, options={})
    if user
      self.readers.all({:conditions => {:id => user.followers, :is_registered => true}, :limit => 3, :order => 'read_receipts.created_at DESC'}.merge(options))
    else
      false
    end
  end
  
  # Get the last three readers of the current user in sentence format
  def num_readers_to_s(current_user = nil)
    r = []
    s = ""
    if current_user
  		self.readers_who_follow(current_user).each do |reader|
  			r << reader.login
  		end

		  r.each_with_index do |reader, i|
  		  if i > 0 and i < r.length - 1
  		    s += ', '
  	    elsif i > 0 and r.length > 1
  	      s += ' and '
  	    end
  		  s += reader
  		  if i == r.length - 1
	        s += " read this"
		    end
  	  end
    end
	  s
  end
  
  # finders
  def self.most_read(options = {})
    Link.all({
      :joins => 'LEFT JOIN read_receipts ON links.id = read_receipts.link_id', 
      :group => :id, 
      :order => 'COUNT(*) DESC',
      :limit => 10
    }.merge(options))
  end
  
  def self.most_read_last_week(options = {})
    Link.all({
      :joins => 'LEFT JOIN read_receipts ON links.id = read_receipts.link_id', 
      :group => :id, 
      :order => 'COUNT(*) DESC',
      :conditions => ['links.created_at > ?', 7.day.ago],
      :limit => 10
    }.merge(options))
  end
  
  def self.most_recent(options = {})
    Link.all({
      :order => 'created_at DESC', 
      :limit => 15
    }.merge(options))
  end
  
  def self.feed_of(user, options = {})
    if user
       Link.all({
         :conditions => {:user_id => user.followee_ids}, 
         :order => 'created_at DESC',
         :limit => 15
       }.merge(options))
    else
      false
    end
  end
  
end
