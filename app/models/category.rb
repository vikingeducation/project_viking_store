class Category < ActiveRecord::Base
  validates  :name, :uniqueness => true , :presence => true
  validates  :description,  :presence => true
  
end
