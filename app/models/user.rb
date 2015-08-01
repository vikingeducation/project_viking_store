class User < ActiveRecord::Base
  validates_confirmation_of :email
  validates :first_name, :last_name, :email, presence: true,
                                            length: {in: 1..64}
  validates :email, :format => { :with => /@/ }


  has_many :addresses, dependent: :nullify

  belongs_to :default_billing_address, class_name:  "Address",
              :foreign_key => :billing_id

  belongs_to :default_shipping_address, class_name:  "Address",
              :foreign_key => :shipping_id

  has_many :orders
  has_many :credit_cards

  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents
  # 1. Overall Platform

  # Last 7 Days

  def name
    self.first_name + " " + self.last_name
  end

  def city
    self.default_shipping_address.city.name
  end

  def state
    self.default_shipping_address.state.name
  end

  def merge_carts(session_cart)
    if cart && session_cart
      merge_session_cart_into_db_cart(session_cart, cart.id)
    else
      create_new_unplaced_order(session_cart)
    end
  end

  def merge_session_cart_into_db_cart(session_cart, cart_id)
    # Rails converts all of our hash keys into strings.
    # The order_contents model expects symbols
    # We convert all the keys into symbols then add in the order id
    keyed_session_cart = session_cart.map do |potential_cart|
      keyed_cart = potential_cart.inject({}){|memo,(k,v)| memo[k.to_sym] = v.to_i; memo}
      keyed_cart[:order_id] = cart_id
      keyed_cart
    end
    OrderContent.create_or_update_many(keyed_session_cart)
  end

  def create_new_unplaced_order(session_cart)
    new_order = Order.create(user_id: self.id,
                               billing_id: self.billing_id,
                               shipping_id: self.shipping_id,
                               checkout_date: nil)
    session_cart.each do |new_cart|
      OrderContent.create(order_id: new_order.id,
                          product_id: new_cart["product_id"].to_i,
                          quantity: new_cart["quantity"].to_i)
    end
  end

  def cart
    self.orders.where("checkout_date IS NULL").first
  end

  def last_order_date
    if self.orders.where("checkout_date IS NOT NULL").order(:checkout_date).last
      self.orders.where("checkout_date IS NOT NULL").order(:checkout_date).last.checkout_date
    else
      "N/A"
    end
  end

  def self.in_last(days = nil)
    if days.nil?
      self.count
    else
      self.where('created_at > ?', DateTime.now - days).count
    end
  end

  def self.get_overall
    overall = {'Last 7 Days' => 7, 'Last 30 Days' => 30, 'Total' => nil}
    overall.each do |key, limit|
      result = []
      result << ["New Users", self.in_last(limit)]
      result << ["Orders", Order.in_last(limit)]
      result << ["New Products", Product.in_last(limit)]
      result << ["Revenue", Order.revenue_in_last(limit)]
      overall[key] = result
    end
    overall
  end

  def rebuild_user_addresses(addresses)
    addresses.reject!{|address| address["street_address"].blank? &&
                                address["city"].blank? &&
                                address["zip_code"].blank?}
    addresses.each do |address|
      a = Address.new(user_id: self.id)
      a.street_address = address["street_address"]
      a.city = City.find_or_create_by(name: address["city"])
      a.state_id = address["state_id"].to_i
      a.zip_code = address["zip_code"].to_i
      a.save!
    end
    self.deorphan_addresses
  end

  def deorphan_addresses
    unless b_address = Address.find_by(id: self.billing_id) && b_address.user_id = self.id
      self.billing_id = nil
    end

    unless s_address = Address.find_by(id: self.shipping_id) && s_address.user_id = self.id
      self.shipping_id = nil
    end
  end

  def self.get_superlatives
    superlatives = {}
    highest_s = User.high_single_order_value.first
    superlatives['Highest Single Order Value'] = [highest_s.full_name,
                                                   highest_s.cost]
    highest_l = User.high_lifetime_value.first
    superlatives['Highest Lifetime Value'] = [highest_l.full_name,
                                               highest_l.cost]
    highest_a = User.high_average_value.first
    superlatives['Highest Average Order Value'] = [highest_a.full_name,
                                                    highest_a.average_value]
    m_orders = User.most_orders.first
    superlatives['Most Orders Placed'] = [m_orders.full_name,
                                           m_orders.number_of_orders]
    return superlatives
  end

  private

    def self.high_single_order_value
      self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity) as cost').
      joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
      where("orders.checkout_date IS NOT NULL").
      group('orders.id, full_name').order('cost DESC').limit(1)
    end

    def self.high_lifetime_value
      self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity) as cost').
      joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
      where("orders.checkout_date IS NOT NULL").
      group('users.id, full_name').order('cost DESC').limit(1)
    end

    def self.high_average_value
      self.select('users.first_name || users.last_name AS full_name, SUM(products.price * order_contents.quantity)/(COUNT(DISTINCT orders.id)) as average_value').
      joins('JOIN orders ON users.id = orders.user_id JOIN order_contents ON order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id').
      where("orders.checkout_date IS NOT NULL").
      group('users.id, full_name').order('average_value DESC').limit(1)
    end

    def self.most_orders
      self.select('users.first_name || users.last_name AS full_name, COUNT(orders.id) as number_of_orders').
      joins('JOIN orders ON users.id = orders.user_id').
      where("orders.checkout_date IS NOT NULL").
      group('users.id, full_name').order('number_of_orders DESC').limit(1)
    end
end











