Week = Struct.new(:day, :quantity, :revenue)
EntireWeek = Struct.new(:sunday, :quantity, :revenue)

class Order < ActiveRecord::Base
  def self.placed_since(time)
    where("checkout_date >= ?", time).count
  end

  def self.total
    count
  end

  def self.avg_value_since(time)
    select("AVG(quantity * price) AS avg_value")
    .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
    .where("checkout_date >= ?", time).last.avg_value
  end

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

  def self.past_7_weeks
    results = []
    7.times do |week_count|
      results << past_7_weeks_helper(week_count)
    end
    results
  end

  def self.past_7_weeks_helper(week_quantity)
    date = Date.today - 7 * week_quantity
    until date.sunday?
      date += 1
    end
    date
  end

  def self.past_week
    date = Date.today
    week = []
    7.times do |past|
      week << date - past
    end
    week
  end

  def self.quantity_revenue_daily(date)
    select("COUNT(*) AS quantity, SUM(quantity * price) AS revenue ")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date BETWEEN ? AND ?", date.to_time, (date + 1).to_time).first
  end

  def self.quantity_revenue_entire_week(sunday)
    select("COUNT(*) AS quantity, SUM(quantity * price) AS revenue ")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date BETWEEN ? AND ?", sunday, (sunday + 6)).first
  end

  def self.avg_value_total
    select("AVG(quantity * price) AS avg_value")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.avg_value
  end

  def self.largest_value_since(time)
    select("MAX(quantity * price) AS largest_val")
    .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
    .where("checkout_date >= ?", time).last.largest_val
  end

  def self.largest_value_total
    select("MAX(quantity * price) AS largest_val")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.largest_val
  end

  def self.revenue_since(time)
    select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date >= ?", time).last.revenue
  end

  def self.total_revenue
    select("SUM(quantity * price) AS revenue")
      .joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products on products.id = order_contents.product_id")
      .where("checkout_date IS NOT NULL").last.revenue
  end
end
