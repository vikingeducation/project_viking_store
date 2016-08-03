class Product < ActiveRecord::Base

  def self.total_products
    self.count
  end

end
