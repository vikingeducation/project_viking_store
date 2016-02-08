class Order < ActiveRecord::Base

  belongs_to :user
  belongs_to :billing_address, class_name: "Address", foreign_key: :billing_id
  belongs_to :shipping_address, class_name: "Address", foreign_key: :shipping_id
  belongs_to :credit_card, class_name: "CreditCard", foreign_key: :credit_card_id

  has_many :order_contents
  has_many :products, through: :order_contents

  has_many :categories, through: :order_contents, source: :product

  validates :credit_card_id, presence: true

  def value
    products.sum("quantity * price")
  end

  def self.recent(num_days = 7)
    Order.processed.where("orders.checkout_date >= ? ", num_days.days.ago.beginning_of_day)
  end

  def self.total_revenue
    Order.processed.joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id ").sum("quantity * price").to_f
  end

  def self.processed
    Order.where("checkout_date IS NOT NULL")
  end

  def self.top_states
    Order.processed.select("states.name").
      joins("JOIN addresses ON addresses.id = orders.billing_id").
      joins("JOIN states ON states.id = addresses.state_id").
      group("states.name").
      order("COUNT(states.name) DESC").
      limit(3)
      .count
  end

  def self.average_value
    Order.select("order_total").from(Order.order_totals, :orders).average("order_total")
  end

  def self.largest_value
    Order.select("order_total").from(Order.order_totals, :orders).maximum("order_total")
  end

  def self.order_totals
    Order.processed.select("orders.*, SUM(price * quantity) AS order_total").joins("JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").group("orders.id")
  end

  def self.orders_by_day
    Order.join_days.select("day, COALESCE(SUM(order_total), 0) as sum, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("day").
      order("day DESC")
  end

 #Joins orders table by week (empty rows where no orders on week)
  def self.orders_by_week
    Order.join_weeks.select("week, COALESCE(SUM(order_total), 0) as SUM, COUNT(order_total) as quantity").
      from(Order.order_totals, :orders).
      group("week").
      order("week DESC")
  end

  def self.join_days
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(MIN(checkout_date)) FROM orders), CURRENT_DATE, '1 DAY'::INTERVAL) day ON DATE(orders.checkout_date) = day"
  end

  def self.join_weeks
    Order.joins "RIGHT JOIN GENERATE_SERIES((SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) week ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = week"
  end
end
