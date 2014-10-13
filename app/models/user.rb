class User < ActiveRecord::Base
  belongs_to :billing, :class_name => "Address" # should be cleared if that address is deleted
  belongs_to :shipping, :class_name => "Address" # should be cleared if that address is deleted

  has_many :addresses, :dependent => :destroy
  has_many :orders, :dependent => :destroy # should only delete carts
  has_many :products, through: :orders
  has_one :credit_card, :dependent => :destroy

  validates :first_name, :last_name, :email, presence: true,
                                             length: { maximum: 64 }
  validates :email,
            :uniqueness => true,
            :format => { :with => /@/ }

  def name
    "#{first_name} #{last_name}"
  end

  def completed_orders
    orders.where(checked_out: true)
  end

  def last_checkout_date
    completed_orders.empty? ? "N/A" : completed_orders.order("created_at DESC").last.checkout_date
  end

  def self.new_users(last_x_days = nil)
    if last_x_days
      where("created_at > ?", Time.now - last_x_days.days).size
    else
      all.size
    end
  end

  def self.top_three_states
    select("states.name AS state_name, COUNT(*) AS users_in_state").
      joins("JOIN addresses ON users.billing_id = addresses.id JOIN states ON states.id = addresses.state_id").
      limit(3).
      order("users_in_state DESC").
      group("states.name")
  end

  def self.top_three_cities
    select("cities.name AS city_name, COUNT(*) AS users_in_city").
      joins("JOIN addresses ON users.billing_id = addresses.id JOIN cities ON cities.id = addresses.city_id").
      limit(3).
      order("users_in_city DESC").
      group("cities.name")
  end

  def self.top_order
    select("users.first_name AS user_first_name, users.last_name AS user_last_name, SUM(purchases.quantity * products.price) AS value").
      joins("JOIN orders ON users.id = orders.user_id JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
      where("orders.checked_out" => true).
      group("orders.id").
      order("value DESC").
      first
  end

  def self.highest_lifetime
    select("users.first_name AS user_first_name, users.last_name AS user_last_name, SUM(purchases.quantity * products.price) AS value").
      joins("JOIN orders ON users.id = orders.user_id JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
      where("orders.checked_out" => true).
      group("users.id").
      order("value DESC").
      first
  end

  def self.highest_average_order

    joins("JOIN orders ON users.id = orders.user_id JOIN purchases ON orders.id = purchases.order_id JOIN products ON purchases.product_id = products.id").
      where("orders.checked_out" => true).
      select("users.id AS user_id, users.first_name AS user_first_name, users.last_name AS user_last_name, (SUM(purchases.quantity * products.price) / COUNT(DISTINCT orders.id)) AS value").
      group("users.id").
      order("value DESC").
      first

  end

  def self.most_orders
    select("users.first_name AS user_first_name, users.last_name AS user_last_name, COUNT(DISTINCT orders.id) AS orders_placed").
      joins("JOIN orders ON users.id = orders.user_id").
      where("orders.checked_out" => true).
      group("users.id").
      order("orders_placed DESC").
      first
  end

end