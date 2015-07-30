class Product < ActiveRecord::Base
<<<<<<< HEAD
=======
  has_many :order_contents
  belongs_to :category
  has_many :orders, through: :order_contents
>>>>>>> 76a0957610bfb218e242a9bb5f2df4c8fe630680

  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

<<<<<<< HEAD
=======
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
>>>>>>> 76a0957610bfb218e242a9bb5f2df4c8fe630680
end
