class Product < ActiveRecord::Base
  validates  :name, :sku, {:uniqueness => true , :presence => true}
  validates  :description,  :presence => true
  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def category
    Category.find_by(id: self.category_id)
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
