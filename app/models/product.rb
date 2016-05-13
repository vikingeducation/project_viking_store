class Product < ActiveRecord::Base
  def self.total
    Product.all.count
  end

  def self.new_products(t)
    Product.where("created_at > CURRENT_DATE - INTERVAL '#{t} DAYS' ").count
  end

  def self.by_category(c)
    Product.where("category_id = ?", c)
  end

  def self.all_with_category
    Product.select("p.id, p.name, p.price, c.name AS cname, p.category_id AS cid")
    .joins("AS p JOIN categories c ON p.category_id = c.id")
  end

  def self.one_product_with_category(id)
    Product.select("products.id, products.name, products.price, c.name AS cname, products.category_id AS cid")
           .joins("products JOIN categories c ON products.category_id = c.id")
           .where("products.id = ?", id)
  end
end
