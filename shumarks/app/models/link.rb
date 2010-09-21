class Link < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :url, :user_id, :name
	validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?.*$/ix
	
	before_validation :fix_url, :fix_name
	
	# If the url doesn't have http:// or https://, add it
	def fix_url
	  if self.url and not self.url.match(/^(http|https):\/\/.*/)
	    self.url = 'http://' + self.url
    end
	end
	
	# If the name is ever empty, populate it with the url
	def fix_name
	  if not self.url or not self.url.blank?
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
		
end
