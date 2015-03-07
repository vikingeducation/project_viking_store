class Order < ActiveRecord::Base

  has_many :order_contents,
            class_name: "OrderContents",
            dependent: :destroy
  has_many :products, through: :order_contents
  belongs_to :user
  belongs_to :shipping_address,
              class_name: "Address",
              foreign_key: :shipping_id
  belongs_to :billing_address,
              class_name: "Address",
              foreign_key: :billing_id

  def self.total_revenue
    Order.select("SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      first.revenue
  end

  def self.revenue_since(time)
    Order.select("SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date > ?", time.to_date).
      first.revenue
  end

  def self.total_orders
    where("checkout_date IS NOT NULL").count
  end

  def self.checked_out_since(time)
    Order.where("checkout_date > ?", time.to_date).count
  end

  def self.average_order_value_since(time)
   self.revenue_since(time) / self.checked_out_since(time)
  end

  def self.average_order_value_all
    self.total_revenue / self.total_orders
  end

  def self.largest_order_value_since(time)
    Order.select("quantity * price AS order_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL AND checkout_date > ?", time.to_date).
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first.
      order_value
  end

  def self.largest_order_value_ever
    Order.select("quantity * price AS order_value").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first.
      order_value
  end

  def self.time_series_by_day
    self.seven_recent_days.each_with_object({}) do |day, time_series|
      time_series[day] = {}
      time_series[day][:day] = day
      time_series[day][:quantity] = self.quantity_and_revenue_on_day(day).quantity
      time_series[day][:revenue] = self.quantity_and_revenue_on_day(day).revenue
    end
  end

  def self.time_series_by_week
    self.seven_recent_sundays.each_with_object({}) do |sunday,time_series|
      time_series[sunday] = {}
      time_series[sunday][:sunday] = sunday
      time_series[sunday][:quantity] = self.quantity_and_revenue_in_week_following(sunday).quantity
      time_series[sunday][:revenue] = self.quantity_and_revenue_in_week_following(sunday).revenue
    end
  end

  # private

  def self.seven_recent_days
    date = Date.today
    seven_days = []
    7.times do |days_ago|
      seven_days << (date - days_ago)
    end
    seven_days
  end

  def self.seven_recent_sundays
    (1..7).each_with_object([]) do |num, sundays|
      sundays << self.nth_recent_sunday(num)
    end
  end

  def self.nth_recent_sunday(n)
    date = Date.today - 7 * n
    until date.sunday?
      date += 1
    end
    date
  end

  def self.quantity_and_revenue_in_week_following(date)
    Order.select("COUNT(*) AS quantity, SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date BETWEEN ? AND ?", date, (date+6)).
      first
  end

  def self.quantity_and_revenue_on_day(date)
    Order.select("COUNT(*) AS quantity, SUM(quantity * price) AS revenue").
      joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date BETWEEN ? AND ?", date.to_time, (date + 1).to_time).
      first
  end

end