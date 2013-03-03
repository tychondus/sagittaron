class UserFile < ActiveRecord::Base
  attr_accessible :description, :name, :size, :uuid
end
