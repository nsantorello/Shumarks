class ReadReceipt < ActiveRecord::Base
  belongs_to :link, :class_name => 'Link', :foreign_key => 'link_id'
  belongs_to :reader, :class_name => 'User', :foreign_key => 'user_id'
end