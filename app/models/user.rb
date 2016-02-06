class User < ActiveRecord::Base
  include Recentable

  belongs_to :billing_address, foreign_key: :billing_id, class_name: "Address"
  belongs_to :shipping_address, foreign_key: :shipping_id, class_name: "Address"

  has_many :addresses
  has_many :orders, dependent: :nullify
  has_many :products, through: :orders, source: :products

  has_one :credit_card, dependent: :destroy

  before_destroy do
    destroy_cart
  end

  validates :first_name, :last_name, :email, presence: true, length: { in: 1...64 }
  validates :email, format: { with: /@/ }, uniqueness: true

  def has_cart?
    orders.any? { |o| o.cart? }
  end

  def default_billing_address_id
    billing_id
  end

  def default_shipping_address_id
    shipping_id
  end

  def destroy_cart
    orders.where( "checkout_date IS NULL" ).destroy_all
  end

  def date_joined
    created_at
  end

  def date_last_order
    if self.orders.any?
      self.orders.reorder('checkout_date').first.checkout_date
    end
  end

  def state
    billing_address.state.name if billing_address
  end

  def city
    billing_address.city.name if billing_address
  end

  def full_name
    first_name + " " + last_name
  end

  ## Queries ##

  def self.top_states
    User.select("states.name").joins("JOIN addresses ON addresses.id = users.billing_id JOIN states ON states.id = addresses.state_id").group("states.name").order("COUNT(states.name) DESC").limit(3).count
  end

  def self.top_cities
    User.select("cities.name").joins("JOIN addresses ON addresses.id = users.billing_id JOIN cities ON cities.id = addresses.state_id").group("cities.name").order("COUNT(cities.name) DESC").limit(3).count
  end

  def self.highest_order_value
    User.select("users.*, SUM(price * quantity)").joins("JOIN orders ON user_id = users.id JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").where("checkout_date IS NOT NULL").group("users.id, order_id").order("SUM(price * quantity) DESC")
  end

  def self.highest_lifetime_order_value
    User.select("users.*, SUM(price * quantity)").joins("JOIN orders ON user_id = users.id JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").where("checkout_date IS NOT NULL").group("users.id").order("SUM(price * quantity) DESC")
  end

  def self.highest_average_order_value
    subquery = User.select("users.*, SUM(price * quantity) AS order_sum").joins("JOIN orders ON user_id = users.id JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").where("checkout_date IS NOT NULL").group("users.id, order_id").order("SUM(price * quantity) DESC").to_sql

     User.select("users.*, AVG(order_values.order_sum)").joins("JOIN (#{subquery}) AS order_values ON order_values.id = users.id").group("users.id").order("avg DESC")
  end

end
