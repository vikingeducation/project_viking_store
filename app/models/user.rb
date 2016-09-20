class User < ActiveRecord::Base
  has_many :addresses

  has_many :orders

  has_many :order_contents, :through => :orders
  has_many :products, through: :order_contents

  belongs_to :default_billing_address, class_name: "Address", :foreign_key => :billing_id
  belongs_to :default_shipping_address, class_name: "Address", :foreign_key => :shipping_id

  has_many :credit_cards, dependent: :destroy

  def default_billing_address_id
    self.default_billing_address.id
  end

  def default_shipping_address_id
    self.default_shipping_address.id
  end

  def self.new_users(days_since)
    self.where("created_at > '#{DateTime.now - days_since}'").count
  end

  def self.total
    self.count
  end
  def self.top_states
    self.select('states.name, COUNT(*) AS num_users')
        .join_with_billing
        .join_with_state
        .group(:state_id, :name)
        .order('num_users desc')
        .limit(3)
  end

  def self.top_cities
    self.select('cities.name, COUNT(*) AS num_users')
        .join_with_billing
        .join_with_city
        .group(:city_id, :name)
        .order('num_users desc')
        .limit(3)
  end

  def self.join_with_orders
    joins("JOIN orders ON orders.user_id = user.id")
  end


  def self.join_with_billing
    joins("JOIN addresses ON users.billing_id = addresses.id")
  end

  def self.join_with_state
    joins("JOIN states ON addresses.state_id = states.id")
  end

  def self.join_with_city
    joins("JOIN cities ON addresses.city_id = cities.id")
  end
end

# class User < ActiveRecord::Base

  #Num users per day in sql
  # User.find_by_sql("
  #   SELECT DATE(created_at) AS day, COUNT(*) AS num_users
  #   FROM Users
  #   GROUP BY day
  #   ORDER BY day
  # ")

  #   SELECT
  #   DATE(days) AS day,
  #   COUNT(orders.*) AS num_orders
  #   FROM GENERATE_SERIES((
  #     SELECT DATE(MIN(checkout_date)) FROM orders
  #   ), CURRENT_DATE, '1 DAY'::INTERVAL) days
  #   LEFT JOIN orders ON DATE(orders.checkout_date) = days
  #   GROUP BY days
  #   ORDER BY days DESC
  # ;
