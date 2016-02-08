class User < ActiveRecord::Base
  include Recentable

  has_many :addresses
  has_many :orders

  belongs_to :default_billing_address, class_name: "Address", foreign_key: :billing_id
  belongs_to :default_shipping_address, class_name: "Address", foreign_key: :shipping_id

  has_many :products, through: :orders

  has_many :credit_cards

  validates :first_name, :last_name, presence: true, length: { maximum: 64 }

  validates :email, presence: true, format: { with: /@/, message: "Needs an @!!!"}

  def self.get_all_with_billing_location
    User.select("users.*, c.name AS c_name, s.name AS s_name")
      .joins("JOIN addresses a ON users.billing_id=a.id")
      .joins("JOIN cities c ON city_id=c.id")
      .joins("JOIN states s ON state_id=s.id")
      .order("users.id")
  end

  def self.get_billing_address(n)
    User.select("a.street_address AS street, c.name AS c_name, s.name AS s_name, a.zip_code AS zip")
      .joins("JOIN addresses a ON users.billing_id=a.id")
      .joins("JOIN cities c ON a.id=c.id")
      .joins("JOIN states s ON a.id=s.id")
      .where("users.id=#{n}")
  end

  def self.get_shipping_address(n)
    User.select("a.street_address AS street, c.name AS c_name, s.name AS s_name, a.zip_code AS zip")
      .joins("JOIN addresses a ON users.shipping_id=a.id")
      .joins("JOIN cities c ON a.id=c.id")
      .joins("JOIN states s ON a.id=s.id")
      .where("users.id=#{n}")
  end

  def self.get_credit_card(n)
    User.select("credit_cards.*")
      .joins("JOIN credit_cards ON users.id=user_id")
      .where("users.id=#{n}")
  end

  def self.get_orders(n)
    User.select("o.*, SUM(p.price * oc.quantity) AS value")
      .joins("JOIN orders o ON users.id=o.id")
      .joins("JOIN order_contents oc ON o.id=oc.order_id")
      .joins("JOIN products p ON oc.product_id=p.id")
      .where("users.id=#{n}")
      .group("o.id")
      .order("o.id")
  end

  def self.get_all_cities_and_states
    User.select("c.name AS city, s.name AS state")
      .joins("AS c JOIN products AS p ON c.id=p.category_id")
      .where("c.id=#{cat_id}")
      .order("p.id")
  end

  def full_name
    first_name + " " + last_name
  end

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
