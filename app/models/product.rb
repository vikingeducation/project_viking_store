class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents

end
