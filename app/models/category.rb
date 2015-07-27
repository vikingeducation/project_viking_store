class Category < ActiveRecord::Base

  has_many :products, dependent: :nullify
  has_many :order_contents, :through => :products
  has_many :orders, through: :order_contents

  validates :name,
            :presence => true,
            :length =>{:in => 4..16},
            :uniqueness => true
end
