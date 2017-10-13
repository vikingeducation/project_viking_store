class Order < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first
  REVENUE = 'order_contents.quantity * products.price'
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago

  def order_statistics
    order_stats_hash = {}
    order_stats_hash[:sevendays_count] = overall_count(Order, SEVEN_DAYS)
    order_stats_hash[:thirtydays_count] = overall_count(Order, THIRTY_DAYS)
    order_stats_hash[:total_count] = overall_count(Order, FIRST_ORDER_DATE.created_at)
    order_stats_hash[:sevendays_average] = average_order_value(SEVEN_DAYS)
    order_stats_hash[:thirtydays_average] = average_order_value(THIRTY_DAYS)
    order_stats_hash[:sevendays_largest] = largest_order_value(SEVEN_DAYS)
    order_stats_hash[:thirtydays_largest] = largest_order_value(THIRTY_DAYS)
    order_stats_hash[:total_average] = average_order_value(FIRST_ORDER_DATE.created_at)
    order_stats_hash[:total_largest] = largest_order_value(FIRST_ORDER_DATE.created_at)
    order_stats_hash
  end

  def by_day_statistics
    time_series_hash = {}
    time_series_hash[:today] = orders_today
    fill_in_rest_of_days(time_series_hash)
    time_series_hash
  end

  def by_week_statistics
    time_series_hash = {}
    time_series_hash[:this_week] = orders_this_week
    fill_in_rest_of_weeks(time_series_hash)
    time_series_hash
  end

  def order_demographics
    order_demo_hash = {}
    order_demo_hash[:highest_single_order_value] = highest_single_value_order
    order_demo_hash[:highest_lifetime_order_value] = highest_lifetime_value_order
    order_demo_hash[:highest_average_order_value] = highest_average_value_order
    order_demo_hash[:most_orders_placed] = most_orders_placed
    order_demo_hash
  end


  private


  def overall_count(model, num_days_ago)
    model.where('created_at >= ?', num_days_ago).count
  end


  def average_order_value(num_days_ago)
    order_values = []
    order_and_value = Order.joins_ordercontents_onto_orders.
                           joins_products_onto_ordercontents.
                           group('order_contents.order_id').
                           where('orders.created_at >= ?', num_days_ago).
                           sum(REVENUE).
                           map{|k,v| [k, v.to_f.round(2)] }

     order_and_value.each do |arr|
       order_values << arr[1]
     end
     average_order_value = (order_values.inject{ |sum, el| sum + el }.to_f / order_values.size).round(2)
  end


  def largest_order_value(num_days_ago)
    order_and_value = Order.joins_ordercontents_onto_orders.
                           joins_products_onto_ordercontents.
                           group('order_contents.order_id').where('orders.created_at >= ?', num_days_ago).
                           order('sum(products.price * order_contents.quantity) DESC').
                           limit(1).
                           sum(REVENUE).
                           map{|k,v| [k, v.to_f.round(2)] }.flatten

   largest_order_value = order_and_value[1]
  end


  def orders_today
    todays_orders = Order.joins_ordercontents_onto_orders.
                          joins_products_onto_ordercontents.
                          where('orders.created_at BETWEEN ? AND ?',
                            Date.today.beginning_of_day,
                            Date.today.end_of_day)
    date_quantity_value(todays_orders, 0)
  end


  def orders_days_ago(num_days_ago)
    orders = Order.joins_ordercontents_onto_orders.
                   joins_products_onto_ordercontents.
                   where('orders.created_at BETWEEN ? AND ?',
                          num_days_ago.day.ago.beginning_of_day,
                          num_days_ago.day.ago.end_of_day)
    date_quantity_value(orders, num_days_ago)
  end


  def orders_this_week
    this_week = Order.joins_ordercontents_onto_orders.
                      joins_products_onto_ordercontents.
                     where('orders.created_at BETWEEN ? AND ?',
                             1.week.ago.beginning_of_day,
                             Date.today.end_of_day)
    date_quantity_value(this_week, 0)
  end


  def orders_weeks_ago(num_weeks_ago)
    orders = Order.joins_ordercontents_onto_orders.
                   joins_products_onto_ordercontents.
                   where('orders.created_at BETWEEN ? AND ?',
                          num_weeks_ago.week.ago.beginning_of_day,
                          (num_weeks_ago - 1).week.ago.end_of_day)
    date_quantity_value(orders, num_weeks_ago)
  end


  def date_quantity_value(orders, num_days_ago)
    { quantity: total_quantity(orders), value: total_value(orders) }
  end


  def total_quantity(orders)
    total_quantity = orders.count
  end


  def total_value(orders)
    total_value = orders.sum(REVENUE).to_f
  end


  def highest_single_value_order
    id_and_value = Order.joins_ordercontents_onto_orders.
                         joins_products_onto_ordercontents.
                         group('order_contents.order_id, orders.user_id').
                         order('sum(products.price * order_contents.quantity) DESC').
                         limit(1).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def highest_lifetime_value_order
    id_and_value = Order.joins_ordercontents_onto_orders.
                         joins_products_onto_ordercontents.
                         group('orders.user_id').
                         limit(1).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def highest_average_value_order
    id_and_value = Order.joins_ordercontents_onto_orders.
                         joins_products_onto_ordercontents.
                         group('order_contents.order_id, orders.user_id').
                         limit(1).
                         average(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def most_orders_placed
    user_id_relation = Order.select(:user_id).group(:user_id).order('count(user_id) DESC').limit(1)

    id_and_value = Order.joins_ordercontents_onto_orders.
                         joins_products_onto_ordercontents.
                         group(:user_id).where(:user_id => user_id_relation).
                         sum(REVENUE).
                         map{|k,v| [k, v.to_f.round(2)] }.flatten
    value_and_name(id_and_value)
  end


  def value_and_name(id_and_value)
    { customer_name: user_name(id_and_value), order_value: value_of_order(id_and_value) }
  end


  def value_of_order(id_and_value)
    value = id_and_value[1]
  end


  def user_name(id_and_value)
    user_info = User.find(id_and_value[0])
    user_name = user_info.first_name + ' ' + user_info.last_name
  end


  def fill_in_rest_of_days(time_series_hash)
    1.upto(6) do |i|
      time_series_hash["#{(Date.today - i).strftime("%m/%d")}"] = orders_days_ago(i)
    end
  end


  def fill_in_rest_of_weeks(time_series_hash)
    2.upto(7) do |i|
      time_series_hash["#{(Date.today - i.weeks).strftime("%m/%d")}"] = orders_weeks_ago(i)
    end
  end


  def self.joins_ordercontents_onto_orders
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
  end


  def self.joins_products_onto_ordercontents
    joins('JOIN products ON products.id = order_contents.product_id')
  end


end
