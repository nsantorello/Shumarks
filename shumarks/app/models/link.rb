include ActionView::Helpers::TextHelper
class Link < ActiveRecord::Base
  
	belongs_to :user
	validates_presence_of :url, :user_id, :name
	validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?.*$/ix
	
	before_validation :fix_url, :fix_name
	
  has_many :read_receipts
	has_many :readers, :through => :read_receipts, :source => :reader
	
	
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
	
	# Shortens a name to only 60 characters
	def short_name
		str = self.name
		wordcount = 60
		shortname = (str.length > wordcount) ? (str[0..wordcount] + "...") : str
		return shortname
	end
	
	# Checking to see if user given has read this link
	def read_by?(user)
	  user and self.readers.find_by_id(user.id)
  end
  
  # Get the readers of this link who follow the given user
  def readers_who_follow(user, options={:limit => 3, :order => 'created_at DESC'})
    if user
      self.readers.all({:conditions => {:id => user.followers}}.merge(options))
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
end
