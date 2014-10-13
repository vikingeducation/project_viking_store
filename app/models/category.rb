class Category < ActiveRecord::Base

  validates :name, presence: true,length: { minimum: 4, maximum: 16 }

  has_many :products

  # before_update :confirm_category
end
