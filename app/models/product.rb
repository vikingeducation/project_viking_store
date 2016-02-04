class Product < ActiveRecord::Base
  def self.total_products_listed
    Product.count()
  end

  def self.total_products_in_last_n_days( n )
    Product.where("created_at > ( CURRENT_DATE - #{n} )").count
  end
end
