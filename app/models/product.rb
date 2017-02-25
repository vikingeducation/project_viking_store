class Product < ApplicationRecord
  def self.get_num_of_new_products(start = Time.now, days_ago = nil)
    result = Product.select("count(*) AS num_new_products")
    unless days_ago.nil?
      result = result.where("products.created_at <= ? AND products.created_at >= ?", start, start - days_ago.days )
    end
    result[0].num_new_products.to_s
  end
end
