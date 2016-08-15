class Product < ActiveRecord::Base
  validates :name, :price, :category_id,
            :presence => true
  validates :price,
            :length =>{within: 0..10000}

  has_many :order_contents

  has_many :orders, :through => :order_contents

  belongs_to :category

end

private
def exists
  Product.where("id = ?", :id).empty?
end
