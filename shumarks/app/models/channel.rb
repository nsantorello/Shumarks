class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :links
  has_and_belongs_to_many :tags
  
  validates_presence_of :user_id, :name
  validates_uniqueness_of :name, :scope => [:user_id], :case_sensitive => false
end
