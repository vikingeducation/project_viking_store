class Order < ActiveRecord::Base

  def self.count_orders(day_range = nil)

    if day_range.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", Time.now - day_range.days).count
    end

  end

  # all new orders within past x days
  def self.calc_revenue(day_range = nil)

    if day_range.nil?
      Order.join_with_products.where("checkout_date IS NOT NULL").sum("products.price * order_contents.quantity")
    else
      Order.join_with_products.where("orders.checkout_date > ?", Time.now - day_range.days).sum("products.price * order_contents.quantity")
    end

  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  # grabs contents of orders
  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  # grabs products of content
  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end
  
end
