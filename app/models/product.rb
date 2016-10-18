class Product < ApplicationRecord
  belongs_to :category
  has_many :order_contents
  has_many :orders, :through => :order_contents

  validates :name, :decsription, :sku, :category_id, :price, :presence => true
  validates :price, :numericality => {:less_than_or_equal_to => 10_000}
end
