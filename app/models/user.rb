class User < ApplicationRecord

  has_many :addresses
  belongs_to :default_billing_address, class_name: "Address", :foreign_key => :billing_id
  belongs_to :default_shipping_address, class_name: "Address", :foreign_key => :shipping_id
  has_many :credit_cards, :dependent => :destroy
  before_destroy :delete_only_cart
  has_many :orders
  has_many :order_contents, :through => :orders
  has_many :products, :through => :order_contents, :source => :order


  validates :first_name, 
            :last_name, 
            :email,
            length: { in: 1..64 }, 
            presence: true

  validates :email, 
            format: { with: /@/}

  # REGIONS = Carmen::Country.named('United States').subregions

  def state_abbrev
    # user_state = self.addresses.first.state.name
    # REGIONS.named(user_state).code
    self.addresses.first.state.abbrev_name unless self.addresses.first.nil?
  end

  def city_name
    self.addresses.first.city.name unless self.addresses.first.nil?
  end

  def displayed_address(type)
    case type
    when "billing"
      u = self.default_billing_address
    when "shipping"
      u = self.default_shipping_address
    else
      return nil
    end
    "#{u.street_address}, #{u.secondary_address}, #{u.city.name}, #{u.state.name}" unless u.nil?
  end

  def joined_date
    created_at.strftime("%m/%d/%y")
  end

  def last_order_dated
    sort_ord = self.orders.order('checkout_date DESC').where.not(:checkout_date => nil)
    sort_ord[0].checkout_date.strftime("%m/%d/%y") if sort_ord.any?
  end

  def check_cart
    self.orders.where(:checkout_date => nil)
  end

  def self.seven_days_users
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

  def self.month_users
    where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
  end

  def self.total_users
    count
  end

  def self.top_three_states
    select("count(users.*) AS num_users, states.name").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN addresses ON addresses.id = orders.billing_id").
    joins("JOIN states ON states.id = addresses.state_id").
    group('states.id').
    order('num_users desc').
    limit(3).distinct
  end

  def self.top_three_cities
    select("count(users.*) AS num_users, cities.name").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN addresses ON addresses.id = orders.billing_id").
    joins("JOIN cities ON cities.id = addresses.state_id").
    group('cities.id').
    order('num_users desc').
    limit(3).distinct
  end

  def self.highest_order_val
    select("users.first_name, users.last_name, order_contents.quantity*products.price AS order_value").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id").
    where.not('orders.checkout_date' => nil).
    order("order_value desc").
    limit(1)
  end

  def self.highest_lifetime_val
    select("users.first_name, users.last_name, SUM(order_contents.quantity*products.price) AS all_orders_value").
    joins("JOIN orders ON orders.user_id = users.id").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id").
    where.not('orders.checkout_date' => nil).
    group("users.id").
    order("all_orders_value desc").
    limit(1)
  end

  def self.highest_avg_order_val
    select("users.first_name, users.last_name, AVG(order_contents.quantity*products.price) AS avg_value").
      joins("JOIN orders ON orders.user_id = users.id").
      joins("JOIN order_contents ON orders.id = order_contents.order_id").
      joins("JOIN products ON products.id = order_contents.product_id").
      where.not('orders.checkout_date' => nil).
      group("users.id").
      order("avg_value desc").
      limit(1)
  end

  def self.most_orders
    select("users.first_name, users.last_name, count(orders.id) AS no_of_orders").
      joins("JOIN orders ON orders.user_id = users.id").
      where.not('orders.checkout_date' => nil).
      group("users.id").
      order("no_of_orders desc").
      limit(1)
  end

  private

  def delete_only_cart
    if self.orders.where(:checkout_date => nil)
      self.orders.where(:checkout_date => nil).destroy_all
    end
  end


end