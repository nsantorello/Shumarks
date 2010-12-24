class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :link
  
  validates_presence_of :user_id
  validates_presence_of :link_id
  
  validates_length_of   :text, :within => 5..1000
end
