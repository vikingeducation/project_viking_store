class Order < ApplicationRecord

  def self.total(num_days=nil)
    if num_days
      Order.where("created_at > ?", num_days.days.ago).count
    else
      Order.all.count
    end
  end

  def self.total_revenue
    Order.select('SUM(price * quantity) AS sum')
                   .join_with_products
                   .where("checkout_date IS NOT NULL")

  end

  def self.with_order_values
    Order.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
          .join_with_products
          .where("checkout_date IS NOT NULL")
          .group("orders.id")
          .order("order_value DESC")
  end

  def self.largest_order_value(num_days=nil)
    if num_days
      Order.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .where("checkout_date <= ?", num_days.days.ago)
            .group("orders.id")
            .order("order_value DESC")
            .limit(1)
    else
      Order.with_order_values.limit(1)
    end
  end

  def self.highest_average_order_value(num_days=nil)
    if num_days
      Order.select("AVG(order_contents.quantity * products.price) AS avg_order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .where("checkout_date <= ?", num_days.days.ago)
            .group("orders.id")
            .order("avg_order_value DESC")
            .limit(1)
    else
      Order.select("AVG(order_contents.quantity * products.price) AS avg_order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .group("orders.id")
            .order("avg_order_value DESC")
            .limit(1)
    end
  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end