class User < ActiveRecord::Base
    
  validates_presence_of :last_name, :first_name, :email
  

  has_many :orders
  has_many :addresses,  :dependent => :destroy
  has_many :credit_cards, :dependent => :destroy
  has_many :cities, through: :addresses, source: :city
  has_many :states, through: :addresses

 accepts_nested_attributes_for :addresses,
                               :reject_if => :all_blank,
                               :allow_destroy => true
  include Recentable

  def self.get_user_info
    User.select("c.name AS city, s.name AS state, DATE(u.created_at) AS joined, u.id, u.first_name, u.last_name AS last_name, COUNT(o.id) AS totals")
      .joins("AS u LEFT JOIN addresses AS a ON u.billing_id = a.id")
      .joins("LEFT JOIN cities AS c ON c.id=a.city_id")
      .joins("LEFT JOIN states AS s ON s.id=a.state_id")
      .joins("LEFT JOIN orders AS o ON o.user_id = u.id")
      .order("u.id").group("u.id,s.name,c.name")
  end

  def self.get_users_orders_info

    User.select("c.name AS city, s.name AS state, DATE(u.created_at) AS joined, u.id, u.first_name, u.last_name AS last_name, COUNT(o.id) AS totals")
      .joins("AS u LEFT JOIN addresses AS a ON u.billing_id = a.id")
      .joins("LEFT JOIN cities AS c ON c.id=a.city_id")
      .joins("LEFT JOIN states AS s ON s.id=a.state_id")
      .joins("LEFT JOIN orders AS o ON o.user_id = u.id")
      .order("u.id").group("u.id,s.name,c.name")

    users_info = []
    user_info = {}
    user_info['orders'] = Order.user_order_info(user.id)

    user_info['addresses'] = user.addresses

    if !user.shipping_id.nil?
      user_info['shipping'] = Address.find(user.shipping_id) 
      user_info['shipping_city'] = City.find(user_info['shipping'].city_id)
      user_info['shipping_state'] = State.find(user_info['shipping'].state_id)
    else
       user_info['shipping'] = Address.new
       user_info['billing'] = Address.new
       user_info['shipping_city'] = City.new
       user_info['shipping_state'] = State.new
       user_info['billing_city'] = City.new
       user_info['billing_state'] = State.new   
    end  

    if !user.billing_id.nil?
      user_info['billing'] = Address.find(user.billing_id)
      user_info['billing_city'] = City.find(user_info['billing'].city_id) 
      user_info['billing_state'] = State.find(user_info['billing'].state_id)
    end
      
    user_info['credit_card'] = CreditCard.find_by_user_id(user.id)
    
    if !user_info['credit_card'].nil?
      card = user_info['credit_card'].card_number
      card = card.chars.each_slice(4).map(&:join)*'-'
      user_info['credit_card'].card_number = card 
    else
      user_info['credit_card'] = CreditCard.new
    end  

    users_info << user_info
  
  end

  def self.get_detailed_user_info(user)
    user_info = {}
    user_info['orders'] = Order.user_order_info(user.id)

    user_info['addresses'] = user.addresses

    if !user.shipping_id.nil?
      user_info['shipping'] = Address.find(user.shipping_id) 
      user_info['shipping_city'] = City.find(user_info['shipping'].city_id)
      user_info['shipping_state'] = State.find(user_info['shipping'].state_id)
    else
       user_info['shipping'] = Address.new
       user_info['billing'] = Address.new
       user_info['shipping_city'] = City.new
       user_info['shipping_state'] = State.new
       user_info['billing_city'] = City.new
       user_info['billing_state'] = State.new   
    end  

    if !user.billing_id.nil?
      user_info['billing'] = Address.find(user.billing_id)
      user_info['billing_city'] = City.find(user_info['billing'].city_id) 
      user_info['billing_state'] = State.find(user_info['billing'].state_id)
    end
      
    user_info['credit_card'] = CreditCard.find_by_user_id(user.id)
    
    if !user_info['credit_card'].nil?
      card = user_info['credit_card'].card_number
      card = card.chars.each_slice(4).map(&:join)*'-'
      user_info['credit_card'].card_number = card 
    else
      user_info['credit_card'] = CreditCard.new
    end  

    user_info
  
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
