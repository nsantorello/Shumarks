require 'digest/sha1'
class User < ActiveRecord::Base
  include ApplicationHelper
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_inclusion_of    :is_registered, :in => [true, false]
  validates_presence_of     :password,                    :if => :password_required?
  validates_presence_of     :password_confirmation,       :if => :password_required?
  validates_length_of       :password, :within => 4..40,  :if => :password_required?
  validates_confirmation_of :password,                    :if => :password_required?
  validates_length_of       :login,    :within => 3..40,  :if => :registering?
  validates_length_of       :email,    :within => 3..100, :if => :registering?
  validates_format_of       :login, :with => /\A[a-z0-9_-]*\Z/i, :if => :registering?
  validates_format_of       :email, :with => /\A[^@\s]+@[-a-z0-9]+\.+[a-z]{2,}\Z/i, :if => :registering?
  validates_uniqueness_of   :login, :email, :case_sensitive => false, :if => :registering?
  
  before_save :encrypt_password
  before_validation :generate_salt
  
  has_many :links
  
  has_many :follows_as_follower,  :foreign_key => 'follower_id',    :class_name => 'Follow'
  has_many :follows_as_followee,  :foreign_key => 'followee_id',    :class_name => 'Follow'
  has_many :followers,            :through => :follows_as_followee
  has_many :followees,            :through => :follows_as_follower
  
  has_many :read_receipts
  has_many :links_read, :through => :read_receipts, :source => :link
  
  has_many :sessions
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :is_registered, :login, :email, :password, :password_confirmation, :first_name, :last_name, :bio
  
  # follows given user, returns success or failure
  def follow(user)
    if user and user.is_registered and self.is_registered and !self.followees.find_by_id(user.id) and user.id != self.id
      self.followees << user
      self.save()
    else
      false
    end
  end
  
  # unfollows given user, returns success or failure
  def unfollow(user)
    if user and self.followees.find_by_id(user.id) and user.id != self.id
      self.followees.delete(user)
      self.save()
    else
      false
    end
  end
  
  def following?(user)
    user and self.followees.find_by_id(user.id)
  end
  
  def followed_by?(user)
    user and self.followers.find_by_id(user.id)
  end
  
  def home_page_url
    "#{ENV['hostname']}/#{self.login}"
  end
  
  def profile_pic_url
    gravatar_url_for(self.email)
  end
  
  def read(link)
    if link and !self.has_read?(link) and link.user.id != self.id
      self.links_read << link
      self.save()
    else
      false 
    end
  end
  
  def has_read?(link)
    link and self.links_read.find_by_id(link.id)
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at() && Time.now.utc() < remember_token_expires_at() 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  # Return the queue of links for this user
  def queue_xml
    doc = Builder::XmlMarkup.new( :target => out_string = "", :indent => 2 )
    doc.queue("login" => self.login) {
      self.links.each { |link| 
        doc.link("id" => link.id) {
          doc.name(link.name)
          doc.offsite_url(link.url)
          doc.onsite_url("http://#{ENV['hostname']}/v/#{link.id}?s=#{self.salt}")
          doc.created(link.created_at)
        }
      }
    }
    return out_string
  end

  protected
    def encrypt_password
      unless password.blank?
        self.crypted_password = encrypt(password)
      end
    end
    
    def generate_salt
      if registering? and login and salt.blank?
        self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
      end
    end
      
    def password_required?
      registering? and (crypted_password.blank? or !password.blank?)
    end
    
    def registering?
      self.is_registered
    end
end
