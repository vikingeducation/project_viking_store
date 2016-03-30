class User < ActiveRecord::Base

  belongs_to :default_billing_address,
              class_name: "Address",
              :foreign_key => :billing_id

  belongs_to :default_shipping_address,
              class_name: "Address",
              :foreign_key => :shipping_id

  has_many :orders
  has_many :credit_cards
  has_many :addresses

  validates :first_name, :last_name, :email,
              presence: true,
              length: { in: 1..64 }

  validates :email, uniqueness: true,
                    format: { with: /@/ }

  accepts_nested_attributes_for :addresses,
                                reject_if: :all_blank

  accepts_nested_attributes_for :orders, allow_destroy: true

  def self.new_users_in_last_n_days( n )
    User.where("created_at > ( CURRENT_DATE - #{n} )").count
  end

  def self.top_states
    join_billing_state.select("states.name, COUNT(states.name) AS state_count").group("states.name").order("state_count DESC").limit(3)
  end

  def self.top_cities
    join_billing_city.select("cities.name, COUNT(cities.name) AS city_count").group("cities.name").order("city_count DESC").limit(3)
  end

  def self.join_billing_state
    User.joins( "JOIN addresses ON users.billing_id = addresses.id JOIN states ON addresses.state_id = states.id" )
  end

  def self.join_billing_city
    User.joins( "JOIN addresses ON users.billing_id = addresses.id JOIN cities ON addresses.city_id = cities.id" )
  end

  def self.get_billing_state
    join_billing_state.select("states.name AS state_name")
  end

  def self.get_billing_city
    join_billing_city.select("cities.name AS city_name")
  end

  def self.highest_lifetime_value
    join_user_product.select( "users.first_name, users.last_name, SUM( products.price * order_contents.quantity ) AS total_revenue ").group( "users.first_name, users.last_name" ).order("total_revenue DESC").limit(1)
  end

  def self.highest_single_order
    join_user_product.select( "users.first_name, users.last_name, MAX( products.price * order_contents.quantity ) AS highest ").group( "users.first_name, users.last_name" ).order("highest DESC").limit(1)
  end

  def self.highest_average_value
    join_user_product.select( "users.first_name, users.last_name, AVG( products.price * order_contents.quantity ) AS highest ").group( "users.first_name, users.last_name" ).order("highest DESC").limit(1)
  end

  def self.user_most_orders
    User.joins("JOIN orders ON orders.user_id = users.id").select( "users.first_name, users.last_name, COUNT(*) AS most_orders ").group( "users.first_name, users.last_name" ).order("most_orders DESC").limit(1)
  end

  def self.join_user_product
    User.joins("JOIN orders ON orders.user_id = users.id
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products ON order_contents.product_id = products.id")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def recent_checkout_date
    orders.where.not(checkout_date: nil).
          order("checkout_date DESC")
          .first || "n/a"
  end

  def cart
    orders.find_by(checkout_date: nil) || 'n/a'
  end
end
