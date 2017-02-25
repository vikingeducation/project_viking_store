class Order < ApplicationRecord

  def self.new_orders_count(days_ago=7, n=0)
    o = Order.where("checkout_date <= current_date - '#{n * days_ago} days'::interval AND checkout_date > current_date - '#{(n + 1) * days_ago} days'::interval").count
  end

  def self.recent_revenue(days_ago=nil, n=0)
    days_ago = days_ago ? "AND checkout_date <= current_date - '#{n * days_ago} days'::interval AND checkout_date > current_date - '#{(n + 1) * days_ago} days'::interval " : ''
    r = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id').joins('JOIN products ON products.id = product_id').where("checkout_date IS NOT NULL #{days_ago}").sum('price * quantity').to_i
  end

end
