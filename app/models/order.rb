Week = Struct.new(:day, :quantity, :revenue)
EntireWeek = Struct.new(:sunday, :quantity, :revenue)

class Order < ActiveRecord::Base
  validates :user_id, :shipping_id, :billing_id, presence: true

  belongs_to :user
  has_many :order_contents, class_name: "OrderContents", dependent: :destroy
  has_many :products, through: :order_contents
  has_many :categories, through: :products

  def self.placed_since(time)
    where('checkout_date >= ?', time).count
  end

  def self.user_order(user_id)
    return all unless user_id
    where(user_id: user_id)
  end

  def status
    if checkout_date.nil?
      'UNPLACED'
    else
      'PLACED'
    end
  end

  def value
    total = 0
    order_contents.each do |item|
      total += item.quantity * item.product.price
    end
    total
  end

  def self.total
    count
  end

  # selects the avg value for all orders from a certain date to now
  def self.avg_value_since(time)
    select('AVG(quantity * price) AS avg_value')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date >= ?', time).group('order_id').last.avg_value
  end

  # selects the average of all order totals
  def self.avg_value_total
    select('AVG(quantity * price) AS avg_value')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date IS NOT NULL').last.avg_value
  end

  # selects the highest order value from a certain date to now
  def self.largest_value_since(time)
    select('MAX(quantity * price) AS largest_val')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date >= ?', time).last.largest_val
  end

  # selects the highest order value of all orders
  def self.largest_value_total
    select('MAX(quantity * price) AS largest_val')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date IS NOT NULL').last.largest_val
  end

  # selects total revenue from a certain date to now
  def self.revenue_since(time)
    select('SUM(quantity * price) AS revenue')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date >= ?', time).last.revenue
  end

  # selects the total revenue from all orders
  def self.total_revenue
    select('SUM(quantity * price) AS revenue')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date IS NOT NULL').last.revenue
  end

  # selects the quantity and revenue for a given day
  def self.quantity_revenue_daily(date)
    select('COUNT(*) AS quantity, SUM(quantity * price) AS revenue')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date BETWEEN ? AND ?', date.to_time, (date + 1).to_time).first
  end

  # selects the quantity and revenue for a given week
  def self.quantity_revenue_entire_week(sunday)
    select('COUNT(*) AS quantity, SUM(quantity * price) AS revenue')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id')
      .where('checkout_date BETWEEN ? AND ?', sunday, (sunday + 6)).first
  end

  # returns an array of Week structs for each day of the past week
  def self.past_week_data
    results = []
    past_week.each do |day|
      day_info = Week.new
      day_info.day = day
      day_info.quantity = quantity_revenue_daily(day).quantity
      day_info.revenue = quantity_revenue_daily(day).revenue
      results << day_info
    end
    results
  end

  # returns an array of EntireWeek structs for the past seven weeks
  def self.past_7_weeks_data
    results = []
    past_7_weeks.each do |sun|
      week_info = EntireWeek.new
      week_info.sunday = sun
      week_info.quantity = quantity_revenue_entire_week(sun).quantity
      week_info.revenue = quantity_revenue_entire_week(sun).revenue
      results << week_info
    end
    results
  end

  # returns the array of dates of the past 7 sundays
  def self.past_7_weeks
    results = []
    7.times do |week_count|
      results << past_7_weeks_helper(week_count)
    end
    results
  end

  # helper method to get past 7 sundays
  def self.past_7_weeks_helper(week_quantity)
    date = Date.today - 7 * week_quantity
    date += 1 until date.sunday?
    date
  end

  # returns the array of of the past 7 days
  def self.past_week
    date = Date.today
    week = []
    7.times do |past|
      week << date - past
    end
    week
  end

end
