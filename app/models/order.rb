class Order < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card

  has_many :order_contents, :dependent => :destroy
  has_many :products,
           :through => :order_contents

  has_many :categories,
           :through => :products,
           :source => :category

  belongs_to :order_billing_address,
             :foreign_key => :billing_id,
             class_name: "Address",
             optional: true

  belongs_to :order_shipping_address,
             :foreign_key => :shipping_id,
             class_name: "Address",
             optional: true


  def status
    self.checkout_date ? "Placed" : "Unplaced"
  end

  def checkout_day
    self.checkout_date ? self.checkout_date.to_date : "Unplaced"
  end


  def value
    self.order_contents.inject(0) { |sum, e| sum + e.product.price * e.quantity  }
  end

  def self.new_orders_7
    Order.where("checkout_date > '#{Time.now.to_date - 7}'").count
  end

  def self.new_orders_30
    Order.where("checkout_date > '#{Time.now.to_date - 30}'").count
  end

  def self.total_orders
    Order.where("orders.checkout_date IS NOT null").count
  end

  def self.largest_order_value_30
    Order.select("sum(price * quantity) AS order_value").join_order_with_order_contents.join_order_contents_with_product.where("
    orders.checkout_date IS NOT null").where("checkout_date > '#{Time.now.to_date - 30}'").group("orders.id").order("order_value desc").limit(1)
  end

  def self.largest_order_value_7
    Order.select("sum(price * quantity) AS order_value").join_order_with_order_contents.join_order_contents_with_product.where("
    orders.checkout_date IS NOT null").where("checkout_date > '#{Time.now.to_date - 7}'").group("orders.id").order("order_value desc").limit(1)
  end



  def self.top_single_order
    Order.select("users.first_name,users.last_name, sum(price * quantity) AS revenue
    ").join_order_with_products_with_user.where("
    orders.checkout_date IS NOT null").group("
    orders.id").order("revenue desc").limit(1)
  end

  def self.top_value_customer
    Order.select("users.first_name,users.last_name, sum(price * quantity) AS revenue
    ").join_order_with_products_with_user.where("
    orders.checkout_date IS NOT null").group("
    users.id").order("revenue desc").limit(1)
  end

  def self.top_avg_order
    Order.select("users.first_name,users.last_name,
    sum(price * quantity) AS revenue,
    count(distinct orders.id) AS count_num,
    sum(price * quantity) / count(distinct orders.id) AS avg_price
    ").join_order_with_products_with_user.where("
    orders.checkout_date IS NOT null").group("
    users.id").order("revenue / count_num desc").limit(1)
  end

  def self.user_with_most_orders
    Order.select("users.first_name,users.last_name, count(distinct orders.id) AS orders_num
    ").join_order_with_products_with_user.where("
    orders.checkout_date IS NOT null").group("
    users.id").order("orders_num desc").limit(1)
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
