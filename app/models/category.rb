class Category < ActiveRecord::Base
validates :name, 
          :presence => true,
          :length => {:within => 4..16}
validates :id, :presence => true

def initial_table
  # @table_data = Category.joins("JOIN products ON products.category_id = category.id")
  # .select("product_id").group("products.category_id = category.id")
end

def get_prices

end


end
