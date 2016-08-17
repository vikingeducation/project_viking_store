class User < ActiveRecord::Base
  has_many :addresses
  has_many :orders
  has_many :credit_cards, dependent: :destroy
  belongs_to :billing_address, :class_name => "Address",
             foreign_key: :billing_id
  
  belongs_to :shipping_address, :class_name => "Address",
             foreign_key: :shipping_id

  accepts_nested_attributes_for :addresses,
                                :allow_destroy => true,
                                :reject_if => :all_blank

  validates :first_name, :last_name, :email, presence: true
  validates :first_name, :last_name, :email, length: { in: 1..64 }
  validates :email, 
            :format => { :with => /@/ }

  def name
    "#{first_name} #{last_name}"
  end

  def self.created_last_seven_days
    User.where('created_at > ?', Time.now - 7.days)
  end

  def self.created_last_thirty_days
    User.where('created_at > ?', Time.now - 30.days)
  end

  def self.top_three_states
    User.select("states.name, COUNT(states.id) as user_count")
        .joins("JOIN addresses ON users.billing_id=addresses.id")
        .joins("JOIN states ON addresses.state_id=states.id")
        .group("states.name")
        # .order("user_count DESC, states.name" )  
        # .limit(3)  
  end

  def self.top_three_cities
    User.select("cities.name, COUNT(users.id) as user_count")
        .joins("JOIN addresses ON users.billing_id=addresses.id")
        .joins("JOIN cities ON addresses.city_id=cities.id")
        .group("states.name")
        .order("user_count DESC, cities.name" )  
        .limit(3)  
  end

  def self.max_order
    User.select("users.first_name, users.last_name, MAX(order_contents.quantity * products.price) AS max")
        .join_users_order_contents_products
        .group(:last_name, :first_name) 
        .order("max DESC")
        .limit(1)
        .first
        
        
  end

  def self.highest_life_time_value
    select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_total")
    .join_users_order_contents_products
    .group(:last_name, :first_name)
    .order("order_total DESC")
    .limit(1)
    .first
  end

  def self.highest_average_order
    select("CONCAT(users.first_name, ' ', users.last_name) AS full_name, AVG(order_contents.quantity * products.price) AS average_order")
    .join_users_order_contents_products
    .group(:last_name, :first_name)
    .order("average_order DESC")
    .limit(1)
    .first
  end

  def self.most_orders
    select("CONCAT(users.first_name, ' ', users.last_name) AS full_name, COUNT(orders.user_id) AS total_orders")
    .join_users_order_contents_products
    .group(:last_name, :first_name)
    .order("total_orders DESC")
    .limit(1)
    .first
  end

  def self.join_users_order_contents_products
     joins("JOIN orders ON users.id=orders.user_id")
    .joins("JOIN order_contents ON orders.id=order_contents.order_id")
    .joins("JOIN products ON order_contents.product_id=products.id")
  end
end
