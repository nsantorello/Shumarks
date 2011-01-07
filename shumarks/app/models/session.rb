class Session < ActiveRecord::Base
  validates_presence_of :ruby_session_id

  has_many :read_receipts
  has_many :links_read, :through => :read_receipts, :source => :link
  
  belongs_to :user
end