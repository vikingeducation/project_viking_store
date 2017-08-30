class User < ApplicationRecord
  # A User has many Addresses, and one default billing and shipping Address.
  # If a User is destroyed, we also destroy all associated Addresses.
  has_many :addresses, dependent: :destroy
  belongs_to :default_billing_address, class_name: "Address", foreign_key: :billing_id
  belongs_to :default_shipping_address, class_name: "Address", foreign_key: :shipping_id

  # a User has many Orders.
  # If a User is destroyed, we also destroy his Orders.
  has_many :orders, dependent: :destroy

  # a User has many CreditCards through Orders.
  # If a User is destroyed, we will also destroy associated CreditCards.
  has_many :credit_cards, -> { distinct }, through: :orders, source: :credit_card, dependent: :destroy

  # a User has many OrderContents through Orders.
  # a User thus also has many Products through OrderContents.
  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents, source: :product


  # calculates the number of new Users that signed up within a number of
  # days from the current day
  def self.new_users(within_days)
    User.where("created_at >= ? ", Time.now - within_days.days).count
  end

  # finds the User with the most Orders placed
  def self.user_with_most_orders_placed
    Order
    .joins("JOIN users ON users.id = orders.user_id")
    .where("checkout_date IS NOT NULL")
    .select("users.first_name, users.last_name, COUNT(orders.id) AS order_count")
    .group("users.id, users.first_name, users.last_name")
    .order("order_count DESC")
    .limit(1)
    .first
  end

  # finds the User with the highest single Order value.
  def self.user_with_highest_single_order_value
    Order.revenue_per_order.order("revenue DESC").limit(1).first
  end

  # finds the User with the highest lifetime revenue value.
  def self.user_with_highest_lifetime_value
    Order.revenue_per_user.order("revenue DESC").limit(1).first
  end

  # finds the User with the highest average Order value.
  def self.user_with_highest_average_order_value
    OrderContent.find_by_sql(
      "
      SELECT users.first_name, users.last_name, ROUND(SUM(order_contents.quantity * products.price) / (SELECT COUNT(orders.id) FROM orders WHERE orders.checkout_date IS NOT NULL AND orders.user_id = users.id), 2) AS average_order_value
      FROM users
      JOIN orders ON orders.user_id = users.id
      JOIN order_contents ON order_contents.order_id = orders.id
      JOIN products ON products.id = order_contents.product_id
      WHERE orders.checkout_date IS NOT NULL
      GROUP BY users.id
      ORDER BY average_order_value DESC
      LIMIT 1;
      "
    ).first
  end
end
