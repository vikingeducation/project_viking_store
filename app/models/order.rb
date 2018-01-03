class Order < ApplicationRecord

  has_many :order_contents
  accepts_nested_attributes_for :order_contents
  has_many :products, through: :order_contents
  has_many :categories, through: :products
  belongs_to :user

  include CountSince

  FIRST_ORDER_DATE = Order.select(:created_at).first
  REVENUE = 'order_contents.quantity * products.price'

  def self.order_statistics
    order_stats = {}
    order_stats[:sevendays_count] = count_since(7.days.ago)
    order_stats[:thirtydays_count] = count_since(30.days.ago)
    order_stats[:total_count] = count_since(FIRST_ORDER_DATE.created_at)
    order_stats[:sevendays_average] = average_order_value(7.days.ago)
    order_stats[:thirtydays_average] = average_order_value(30.days.ago)
    order_stats[:sevendays_largest] = largest_order_value(7.days.ago)
    order_stats[:thirtydays_largest] = largest_order_value(30.days.ago)
    order_stats[:total_average] = average_order_value(FIRST_ORDER_DATE.created_at)
    order_stats[:total_largest] = largest_order_value(FIRST_ORDER_DATE.created_at)
    order_stats
  end

  def self.by_day_statistics
    time_series = {}
    time_series[:today] = orders_today
    fill_in_rest_of_days(time_series)
    time_series
  end

  def self.by_week_statistics
    time_series = {}
    time_series[:this_week] = orders_this_week
    fill_in_rest_of_weeks(time_series)
    time_series
  end

  def self.order_demographics
    order_demos = {}
    order_demos[:highest_single_order_value] = highest_single_value_order
    order_demos[:highest_lifetime_order_value] = highest_lifetime_value_order
    order_demos[:highest_average_order_value] = highest_average_value_order
    order_demos[:most_orders_placed] = most_orders_placed
    order_demos
  end


  def order_value
    sum = 0
    self.order_contents.each do |f|
      sum += (Product.find(f.product_id).price * f.quantity)
    end
    sum.to_s
  end

  private

  def self.average_order_value(num_days_ago)
    order_values = []
    order_and_value = Order.joins(:products).
                           group('order_contents.order_id').
                           where('orders.created_at >= ?', num_days_ago).
                           sum(REVENUE).
                           map{|k,v| [k, v.to_f.round(2)] }

     order_and_value.each do |arr|
       order_values << arr[1]
     end
     average_order_value = (order_values.inject{ |sum, el| sum + el }.to_f / order_values.size).round(2)
  end


  def self.largest_order_value(num_days_ago)
    order_and_value = Order.joins(:products).
                           group('order_contents.order_id').where('orders.created_at >= ?', num_days_ago).
                           order('sum(products.price * order_contents.quantity) DESC').
                           limit(1).
                           sum(REVENUE).
                           map{|k,v| [k, v.to_f.round(2)] }.flatten

   largest_order_value = order_and_value[1]
  end


  def self.orders_today
    todays_orders = Order.joins(:products).
                          where('orders.created_at BETWEEN ? AND ?',
                            Date.today.beginning_of_day,
                            Date.today.end_of_day)
    date_quantity_value(todays_orders, 0)
  end


  def self.orders_days_ago(num_days_ago)
    orders = Order.joins(:products).
                   where('orders.created_at BETWEEN ? AND ?',
                          num_days_ago.day.ago.beginning_of_day,
                          num_days_ago.day.ago.end_of_day)
    date_quantity_value(orders, num_days_ago)
  end


  def self.orders_this_week
    this_week = Order.joins(:products).
                      where('orders.created_at BETWEEN ? AND ?',
                             1.week.ago.beginning_of_day,
                             Date.today.end_of_day)
    date_quantity_value(this_week, 0)
  end


  def self.orders_weeks_ago(num_weeks_ago)
    orders = Order.joins(:products).
                   where('orders.created_at BETWEEN ? AND ?',
                          num_weeks_ago.week.ago.beginning_of_day,
                          (num_weeks_ago - 1).week.ago.end_of_day)
    date_quantity_value(orders, num_weeks_ago)
  end


  def self.date_quantity_value(orders, num_days_ago)
    { quantity: total_quantity(orders), value: total_value(orders) }
  end


  def self.total_quantity(orders)
    total_quantity = orders.count
  end


  def self.total_value(orders)
    total_value = orders.sum(REVENUE).to_f
  end


  def self.highest_single_value_order
    id_and_value = Order.joins(:products).
                         group('order_contents.order_id, orders.user_id').
                         order('sum(products.price * order_contents.quantity) DESC').
                         limit(1).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def self.highest_lifetime_value_order
    id_and_value = Order.joins(:products).
                         group('orders.user_id').
                         limit(1).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def self.highest_average_value_order
    id_and_value = Order.joins(:products).
                         group('order_contents.order_id, orders.user_id').
                         limit(1).
                         average(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def self.most_orders_placed
    user_id_relation = Order.select(:user_id).group(:user_id).order('count(user_id) DESC').limit(1)

    id_and_value = Order.joins(:products).
                         group(:user_id).where(:user_id => user_id_relation).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def self.value_and_name(id_and_value)
    { customer_name: user_name(id_and_value), order_value: value_of_order(id_and_value) }
  end


  def self.value_of_order(id_and_value)
    value = id_and_value[1]
  end


  def self.user_name(id_and_value)
    user_info = User.find(id_and_value[0])
    user_name = user_info.first_name + ' ' + user_info.last_name
  end


  def self.fill_in_rest_of_days(time_series)
    1.upto(6) do |i|
      time_series["#{(Date.today - i).strftime("%m/%d")}"] = orders_days_ago(i)
    end
  end


  def self.fill_in_rest_of_weeks(time_series)
    2.upto(7) do |i|
      time_series["#{(Date.today - i.weeks).strftime("%m/%d")}"] = orders_weeks_ago(i)
    end
  end


end
