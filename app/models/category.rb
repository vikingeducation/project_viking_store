class Category < ActiveRecord::Base
  has_many :products
  has_many :order_contents, :through => :products
  has_many :orders, :through => :order_contents

  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => {
              :minimum => 4,
              :maximum => 16
            }

  validates :description,
            :presence => true,
            :length => {
              :minimum => 4
            }
end
