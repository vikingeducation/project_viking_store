class Order < ApplicationRecord

  def self.new_orders_count(days=nil, n=0)
    o = Order.where("checkout_date IS NOT NULL #{days_ago(days, n)}").count
  end

  def self.recent_revenue(days=nil, n=0)
    r = Order.join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").sum('price * quantity').to_i
  end

  def self.avg_order_val(days=nil, n=0)
    r = Order.join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").average('price * quantity').to_i
  end

  def self.largest_order_val(days=nil, n=0)
    o = Order.select('SUM(price * quantity) AS total').join_orders_with_order_contents.join_orders_with_products.where("checkout_date IS NOT NULL #{days_ago(days, n)}").group('order_id').order('total DESC').first.total
  end

  def self.join_orders_with_order_contents
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
  end

  def self.join_orders_with_products
    joins('JOIN products ON products.id = product_id')
  end

  def self.days_ago(days=nil, n)
    days ? "AND checkout_date <= current_date - '#{n * days} days'::interval AND checkout_date > current_date - '#{(n + 1) * days} days'::interval " : ''
  end



end
