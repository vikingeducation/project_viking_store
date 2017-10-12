class Order < ApplicationRecord

  def order_stats
    order_stats_hash = {}
    order_stats_hash[:seven_day_count] = overall_count(Order, SEVEN_DAYS)
    order_stats_hash[:thirty_day_count] = overall_count(Order, THIRTY_DAYS)
    order_stats_hash[:total_count] = overall_count(Order, FIRST_ORDER_DATE.created_at)
    order_stats_hash[:seven_day_average] = average_order_value(SEVEN_DAYS)
    order_stats_hash[:thirty_day_average] = average_order_value(THIRTY_DAYS)
    order_stats_hash[:thirty_day_largest] = largest_order_value(SEVEN_DAYS)
    order_stats_hash[:thirty_day_largest] = largest_order_value(THIRTY_DAYS)
    order_stats_hash[:total_average] = average_order_value(FIRST_ORDER_DATE.created_at)
    order_stats_hash[:total_largest] = largest_order_value(FIRST_ORDER_DATE.created_at)
    order_stats_hash
  end

  def time_series_stats
    time_series_hash = {}
    time_series_hash[:today] = orders_today
    time_series_hash[:yesterday] = orders_days_ago(1)
    time_series_hash[:two_days_ago] = orders_days_ago(2)
    time_series_hash[:three_days_ago] = orders_days_ago(3)
    time_series_hash[:four_days_ago] = orders_days_ago(4)
    time_series_hash[:five_days_ago] = orders_days_ago(5)
    time_series_hash[:six_days_ago] = orders_days_ago(6)
    time_series_hash[:this_week] = orders_this_week
    time_series_hash[:last_week] = orders_weeks_ago(2)
    time_series_hash[:two_weeks_ago] = orders_weeks_ago(3)
    time_series_hash[:three_weeks_ago] = orders_weeks_ago(4)
    time_series_hash[:four_weeks_ago] = orders_weeks_ago(5)
    time_series_hash[:five_weeks_ago] = orders_weeks_ago(6)
    time_series_hash[:six_weeks_ago] = orders_weeks_ago(7)
    time_series_hash
  end


  private


  def average_order_value(num_days_ago)
    order_values = []
    order_and_value = Order.join_ordercontents_onto_orders
                           .join_products_onto_ordercontents
                           .group('order_contents.order_id')
                           .where('orders.created_at >= ?', num_days_ago)
                           .sum(REVENUE)
                           .map_value_to_float

     order_and_values.each do |arr|
       order_values << arr[1]
     end
     average_order_value = (order_values.inject{ |sum, el| sum + el }.to_f / order_values.size).round(2)
  end


  def largest_order_value(num_days_ago)
    order_and_value = Order.join_ordercontents_onto_orders
                           .join_products_onto_ordercontents
                           .group('order_contents.order_id')
                           .where('orders.created_at >= ?', num_days_ago)
                           .order('sum(products.price * order_contents.quantity) DESC')
                           .limit(1)
                           .sum(REVENUE)
                           .map_value_to_float

   largest_order_value = order_and_value[1]
  end


  def orders_today
    todays_orders = Order.join_ordercontents_onto_orders
                         .join_products_onto_ordercontents
                         .where('orders.created_at BETWEEN ? AND ?',
                                 Date.today.beginning_of_day,
                                 Date.today.end_of_day)
    quantity_and_value
  end


  def orders_days_ago(num_days_ago)
    orders = Order.join_ordercontents_onto_orders
                  .join_products_onto_ordercontents
                  .where('orders.created_at BETWEEN ? AND ?',
                          num_days_ago.day.ago.beginning_of_day,
                          num_days_ago.day.ago.end_of_day)
    quantity_and_value
  end


  def orders_this_week
    this_week = Order.join_ordercontents_onto_orders
                     .join_products_onto_ordercontents
                     .where('orders.created_at BETWEEN ? AND ?',
                             1.week.ago.beginning_of_day,
                             Date.today.end_of_day)
    quantity_and_value
  end


  def orders_weeks_ago(num_weeks_ago)
    orders = Order.join_ordercontents_onto_orders
                  .join_products_onto_ordercontents
                  .where('orders.created_at BETWEEN ? AND ?',
                          num_weeks_ago.week.ago.beginning_of_day,
                          (num_weeks_ago - 1).week.ago.end_of_day)
    quantity_and_value
  end


  def total_quantity(orders)
    total_quantity = orders.count
  end


  def total_value(orders)
    total_value = orders.sum(REVENUE).to_f
  end


  def quantity_and_value
    { quantity: total_quantity(orders), value: total_value(orders) }
  end


end
