class Category < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { in: 4..16 }
  
end
