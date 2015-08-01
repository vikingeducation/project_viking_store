class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true,
                                            length: {in: 1..64}
  validates :email, :format => { :with => /@/ }


  has_many :addresses, dependent: :destroy

  belongs_to :default_billing_address, class_name:  "Address",
              :foreign_key => :billing_id

  belongs_to :default_shipping_address, class_name:  "Address",
              :foreign_key => :shipping_id

  has_many :orders
  has_many :credit_cards, dependent: :destroy

  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents

  accepts_nested_attributes_for :addresses,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  def name
    self.first_name + " " + self.last_name
  end

  def city
    self.default_shipping_address.city.name
  end

  def state
    self.default_shipping_address.state.name
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
