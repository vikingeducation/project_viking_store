class Product < ApplicationRecord

  def get_product_count(n_of_days)
    Product.where("created_at > NOW() - INTERVAL '? days'", n_of_days).count
  end

end
