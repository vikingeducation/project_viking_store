class Category < ApplicationRecord

  has_many :products
  has_many :order_contents, :through => :products
  has_many :orders, :through => :order_contents

  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => {:in => 4..16}

end
