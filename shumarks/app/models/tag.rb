class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 20
  
  has_and_belongs_to_many :links
  
  before_validation :trim_name
  
  def self.create_all(tags_to_add)
    result = []
    if tags_to_add
      for t in tags_to_add.split(',')
        t = t.strip
        tag = self.new(:name => t)
        
        if not tag.save
          tag = self.find_by_name(t)
          if not tag
            next
          end
        end
        
        result << tag
      end
    end
    result
  end
  
private  
  def trim_name 
    self.name = self.name.strip if self.name
  end
  
end
