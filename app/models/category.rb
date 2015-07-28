class Category < ActiveRecord::Base
  has_many :products

  validates  :name, {:uniqueness => true , :presence => true}
  validates  :description, :presence => true
  

end
