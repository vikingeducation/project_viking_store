class Product < ActiveRecord::Base
  validates :name, :price, :category_id,
            :presence => true
  validates :price,
            :length =>{within: 0..10000}

end

private
def exists
  Product.where("id = ?", :id).empty?
end
