class Product < ActiveRecord::Base
  has_many :order_contents
  belongs_to :category
  has_many :orders, through: :order_contents

  def self.product_count(timeframe = 1000000)

    Product.where("created_at > ?", timeframe.days.ago).count

  end

  def self.category_items(cat_id)
    Product.where("category_id = ?", cat_id).select("id, name")
  end

  def self.delete_category(cat_id)
    Product.where("category_id = ?", cat_id)
            .update_all(:category_id => nil)
  end

  def times_ordered
    Product.joins("JOIN order_contents ON products.id = order_contents.product_id").
    joins("JOIN orders ON orders.id = order_contents.order_id").
    where("product_id = #{self.id} AND orders.checkout_date IS NOT NULL").count
  end

  def carts_in
    Product.joins("JOIN order_contents ON products.id = order_contents.product_id").
    joins("JOIN orders ON orders.id = order_contents.order_id").
    where("product_id = #{self.id} AND orders.checkout_date IS NULL").count
  end
end
