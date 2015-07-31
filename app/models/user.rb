class User < ActiveRecord::Base
  has_many :created_addresses, :class_name => 'Address', :dependent => :destroy
  accepts_nested_attributes_for :created_addresses, :reject_if => :all_blank, :allow_destroy => true

  belongs_to :default_billing_address, :class_name => 'Address', :foreign_key => :billing_id
  belongs_to :default_shipping_address, :class_name => 'Address', :foreign_key => :shipping_id

  has_many :credit_cards, :dependent => :destroy

  has_many :orders, :dependent => :nullify # make dependent if not checked out
  has_many :order_contents, :through => :orders
  has_many :products, :through => :order_contents


  validates :first_name, :last_name, :email, :presence => true, :length => { :in => 1..64 }
  validates :email, :format => { :with => /.+@.+/, :message => "format is invalid." }

  validates_confirmation_of :email


# Storefront methods
  def has_cart?
    !self.orders.where('checkout_date IS NULL').empty?
  end


  def get_or_build_cart
    if self.has_cart?
      self.get_cart
    else
      self.orders.build
    end
  end



# Portal methods
  def self.get_index_data
    data = User.all.order(:id)
    output = []

    data.each do |user|
      output << [
                  user,
                  user.get_user_city,
                  user.get_user_state,
                  user.get_order_count,
                  user.get_last_order_date
                ]
    end

    output
  end



  def get_user_city
    self.default_billing_address.city.name if self.default_billing_address
  end


  def get_user_state
    self.default_billing_address.state.name if self.default_billing_address
  end


  def get_order_count
    self.orders.where("checkout_date IS NOT NULL").count
  end


  def get_last_order_date
    self.orders.maximum(:checkout_date).to_date if get_order_count > 0
  end


  def get_order_history
    self.products.group("orders.id").order("orders.checkout_date DESC").
            select(
                  "orders.id,
                  orders.created_at,
                  SUM(order_contents.quantity * products.price) AS value,
                  (CASE WHEN orders.checkout_date IS NOT NULL THEN 'PLACED' ELSE 'UNPLACED' END) AS status"
                  )
  end


  def get_billing_address_string
    self.default_billing_address.stringify if self.default_billing_address
  end


  def get_shipping_address_string
    self.default_shipping_address.stringify if self.default_shipping_address
  end


  def get_cart
    self.orders.where("checkout_date IS NULL").first
  end



# Dashboard methods

  def self.count_new_users(day_range = nil)
    if day_range.nil?
      User.all.count
    else
      User.where("created_at > ?", Time.now - day_range.days).count
    end
  end


  # Returns Top 3 Users by City or State
  def self.top_3_by(geography)
    User.joins("JOIN addresses ON users.billing_id = addresses.id
                JOIN #{geography.pluralize} ON addresses.#{geography}_id = #{geography.pluralize}.id").
          group("#{geography.pluralize}.name").
          order("count(distinct users.id) DESC").limit(3).
          count(:id)

  end


  def self.top_users
    { 'Highest Single Order Value' => self.biggest_order,
      'Highest Lifetime Value' => self.highest_lifetime_orders,
      'Highest Average Order Value' => self.highest_average_order,
      'Most Orders Placed' => self.most_orders
    }
  end


  private



# Portal PRIVATE methods



# Dashboard PRIVATE methods
  def self.biggest_order
    result = User.select("users.*,
                          orders.id AS order_id,
                          SUM(products.price * order_contents.quantity) AS order_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id, orders.id").
                  order('order_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.order_value]
  end


  def self.highest_lifetime_orders
    result = User.select("users.*,
                          SUM(products.price * order_contents.quantity) AS lifetime_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('lifetime_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.lifetime_value]
  end


  def self.highest_average_order
    result = User.select("users.*,
                          round( SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id), 2) AS average_order_value").
                  joins("JOIN orders ON users.id = orders.user_id
                         JOIN order_contents ON orders.id = order_contents.order_id
                         JOIN products ON order_contents.product_id = products.id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('average_order_value DESC').
                  first

    [result.first_name + " " + result.last_name, result.average_order_value]
  end


  def self.most_orders
    result = User.select("users.*, COUNT(DISTINCT orders.id) AS order_count").
                  joins("JOIN orders ON users.id = orders.user_id").
                  where("orders.checkout_date IS NOT NULL").
                  group("users.id").
                  order('order_count DESC').
                  first

    [result.first_name + " " + result.last_name, result.order_count]
  end


end
