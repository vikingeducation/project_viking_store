class User < ApplicationRecord
  validates :first_name,
            :last_name,
            :email,
            presence: true,
            length: { in: 1..64 }

  validates :email,
            uniqueness: true,
            format: { with: /@/ }



  # A User has many Addresses, and one default billing and shipping Address.
  # If a User is destroyed, we also destroy all associated Addresses.
  has_many :addresses, dependent: :destroy
  belongs_to :default_billing_address, class_name: "Address", foreign_key: :billing_id
  belongs_to :default_shipping_address, class_name: "Address", foreign_key: :shipping_id

  # A User has many Cities / States through his Addresses.
  has_many :cities, through: :addresses
  has_many :states, through: :addresses

  # a User has many Orders.
  # If a User is destroyed, we want to keep his Orders.
  has_many :orders, dependent: :nullify

  # a User has many CreditCards through Orders.
  # If a User is destroyed, we will also destroy associated CreditCards.
  has_many :credit_cards, dependent: :destroy

  # a User has many OrderContents through Orders.
  # a User thus also has many Products through OrderContents.
  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents, source: :product



  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  # returns the City name of the User's first address
  def first_city
    unless self.addresses.empty?
      self.addresses.first.city.name
    else
      '<span class="text-secondary">N/A</span>'.html_safe
    end
  end

  # returns the State abbreviation of the User's first address
  def first_state
    unless self.addresses.empty?
      self.addresses.first.state.to_s
    else
      '<span class="text-secondary">N/A</span>'.html_safe
    end
  end

  # finds all Orders placed by a User
  def placed_orders
    self.orders.where("checkout_date IS NOT NULL")
  end

  # finds the number of Orders a User has placed (excluding the existing shopping cart)
  def num_placed_orders
    placed_orders.count
  end

  # finds the date of the last Order the User placed
  def last_order_date
    unless placed_orders.empty?
      placed_orders.order("checkout_date DESC").first.checkout_date
    else
      "N/A"
    end
  end

  # checks if the User has an active shopping cart
  def has_shopping_cart?
    !self.orders.where("checkout_date IS NULL").empty?
  end

  # returns the Order that corresponds to a User's shopping cart
  def shopping_cart
    self.orders.where("checkout_date IS NULL").first
  end

  # returns the number of the User's first CreditCard, if it exists
  def card_number
    if self.has_credit_cards?
      self.credit_cards.first.to_s
    else
      "N/A"
    end
  end

  # returns the expiration date of the User's first CreditCard, if it exists
  def card_expiration_date
    if self.has_credit_cards?
      exp_month = self.credit_cards.first.exp_month.to_s
      exp_month = "0" + exp_month if exp_month.length == 1
      "#{exp_month}-#{self.credit_cards.first.exp_year}"
    else
      "N/A"
    end
  end

  # returns the CCV number of the User's first CreditCard, if it exists
  def card_cvv_number
    if self.has_credit_cards?
      if self.credit_cards.first.cvv
        self.credit_cards.first.cvv.to_s
      else
        "N/A"
      end
    else
      "N/A"
    end
  end

  # checks if the User has any CreditCards
  def has_credit_cards?
    !self.credit_cards.empty?
  end

  # gets the User's Order history
  def order_history
    OrderContent
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .joins("JOIN products ON products.id = order_contents.product_id")
    .select("orders.id, orders.checkout_date, SUM(order_contents.quantity * products.price) AS value")
    .group("orders.id, orders.checkout_date")
    .where("orders.user_id = ?", self.id)
    .order("orders.checkout_date DESC")
  end



  ### Analytic Dashboard methods ###

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
