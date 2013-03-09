class UserFile < ActiveRecord::Base
  attr_accessible :description, :name, :size, :file_location, :thumb_location
  
  validates :name, :size, :file_location, :presence => true
    
end
