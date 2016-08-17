class OrderContent < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  def total_price
    if self.product
      quantity * self.product.price
    end
  end
  
  def self.revenue_last_seven_days
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .join_products_order_contents_orders
                .where("order_contents.created_at > ? AND orders.checkout_date IS NOT NULL", Time.now - 7.days).to_a.first.revenue                
  end

  def self.revenue_last_thirty_days
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .join_products_order_contents_orders
                .where("order_contents.created_at > ? AND orders.checkout_date IS NOT NULL", Time.now - 30.days).to_a.first.revenue                
  end

  def self.total_revenue
    OrderContent.select("SUM(products.price * order_contents.quantity) AS revenue")
                .join_products_order_contents_orders
                .where("orders.checkout_date IS NOT NULL")
                .to_a.first.revenue                
  end

  

  def self.everything
    OrderContent.select("order_contents.created_atq, (products.price * order_contents.quantity) AS revenue")
                .join_products_order_contents_orders
                .where("orders.checkout_date IS NOT NULL")                
  end  

  def self.avg_order_value
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders.to_a

    order_count = orders.count
    values = orders.map { |order| order.order_value }
    values.inject(:+) / order_count.to_f

  end

  def self.avg_order_value_last_seven_days
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders
            .where("orders.created_at > ?", Time.now - 7.days)
            .to_a
    order_count = orders.count
    values = orders.map { |order| order.order_value }
    (values.inject(:+) / order_count.to_f).round(2)

  end

  def self.avg_order_value_last_thirty_days
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders
            .where("orders.created_at > ?", Time.now - 30.days)
            .to_a
    order_count = orders.count
    values = orders.map { |order| order.order_value }
    (values.inject(:+) / order_count.to_f).round(2)

  end

  def self.max_order
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders.to_a

    values = orders.map { |order| order.order_value }
    values.max
  end

  def self.max_order_last_seven_days
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders
            .where("orders.created_at > ?", Time.now - 7.days)
            .to_a
    values = orders.map { |order| order.order_value }
    values.max
  end

  def self.max_order_last_thirty_days
    orders = OrderContent.select("(products.price * order_contents.quantity) AS order_value")
            .join_products_order_contents_orders
            .where("orders.created_at > ?", Time.now - 30.days)
            .to_a
    values = orders.map { |order| order.order_value }
    values.max
  end

  def self.join_products_order_contents_orders
    joins("JOIN products ON order_contents.product_id=products.id")
    .joins("JOIN orders ON orders.id=order_contents.order_id")
  end

end
