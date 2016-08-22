class Order < ApplicationRecord


  def self.new_orders_7
    Order.where("checkout_date > '#{Time.now.to_date - 7}'").count
  end

  def self.new_orders_30
    Order.where("checkout_date > '#{Time.now.to_date - 30}'").count
  end

  def self.total_orders
    Order.count
  end

  def self.top_single_order
    Order.select("users.first_name,users.last_name, sum(price * quantity) AS revenue").join_order_with_products_with_user.group("orders.id").order("revenue desc").limit(1)
  end

  def self.top_value_customer
    Order.select("users.first_name,users.last_name, sum(price * quantity) AS revenue").join_order_with_products_with_user.group("users.id").order("revenue desc").limit(1)
  end

  def self.top_avg_order
    Order.select("users.first_name,users.last_name, sum(price * quantity) AS revenue, count(distinct orders.id) AS count_num, sum(price * quantity) / count(orders.id) AS avg_price").join_order_with_products_with_user.group("users.id").order("revenue / count_num desc").limit(1)
  end

  def self.user_with_most_orders
    Order.select("users.first_name,users.last_name, count(distinct orders.id) AS orders_num").join_order_with_products_with_user.group("users.id").order("orders_num desc").limit(1)
  end


  private

  def self.join_order_with_products_with_user
    join_order_with_user.join_order_with_order_contents.join_order_contents_with_product
  end

  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  def self.join_order_with_user
    joins("JOIN users ON orders.user_id = users.id")
  end

  def self.join_order_contents_with_product
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end
