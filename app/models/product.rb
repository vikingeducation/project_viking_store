class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_contents
  has_many :orders , :through => :order_contents


  validates  :name, :sku, {:uniqueness => true , :presence => true}
  validates  :description,  :presence => true
  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
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
