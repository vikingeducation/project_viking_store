class Order < ApplicationRecord

  def order_stats
    first_order_date = Order.select(:created_at).first
    order_stats_hash = {
      seven_day_count: Order.where('created_at >= ?', 7.days.ago).count # create helper method that takes model and days
      thirty_day_count: Order.where('created_at >= ?', 30.days.ago).count # create helper method that takes model and days
      total_count: Order.all.count
      seven_day_average: average_order_value(7.days.ago)
      thirty_day_average: average_order_value(30.days.ago)
      thirty_day_largest: largest_order_value(7.days.ago)
      thirty_day_largest: largest_order_value(30.days.ago)
      total_average: average_order_value(first_order_date.created_at)
      total_largest: largest_order_value(first_order_date.created_at)
    }
  end

  def time_series_stats
    time_series_hash = {
        today: orders_today
        yesterday: orders_days_ago(1)
        two_days_ago: orders_days_ago(2)
        three_days_ago: orders_days_ago(3)
        four_days_ago: orders_days_ago(4)
        five_days_ago: orders_days_ago(5)
        six_days_ago: orders_days_ago(6)
        this_week: orders_this_week
        last_week: orders_weeks_ago(2)
        two_weeks_ago: orders_weeks_ago(3)
        three_weeks_ago: orders_weeks_ago(4)
        four_weeks_ago: orders_weeks_ago(5)
        five_weeks_ago: orders_weeks_ago(6)
        six_weeks_ago: orders_weeks_ago(7)
    }
  end


  private


  def average_order_value(num_days_ago)
    order_values = []
    order_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id') #refactor to own helper method
                           .joins('JOIN products ON products.id = order_contents.product_id') #refactor to own helper method
                           .group('order_contents.order_id').where('orders.created_at >= ?', date)
                           .sum('order_contents.quantity * products.price')
                           .map{|k,v| [k, v.to_f] }

     order_and_values.each do |arr|
       order_values << arr[1]
     end
     average_order_value = (order_values.inject{ |sum, el| sum + el }.to_f / order_values.size).round(2)
  end


  def largest_order_value(num_days_ago)
    order_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                           .joins('JOIN products ON products.id = order_contents.product_id')
                           .group('order_contents.order_id')
                           .where('orders.created_at >= ?', num_days_ago)
                           .order('sum(products.price * order_contents.quantity) DESC')
                           .limit(1)
                           .sum('order_contents.quantity * products.price')
                           .map{|k,v| [k, v.to_f] }

   largest_order_value = order_and_value[1]
  end


  def orders_today
    todays_orders = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                         .joins('JOIN products ON products.id = order_contents.product_id')
                         .where('orders.created_at BETWEEN ? AND ?', Date.today.beginning_of_day, Date.today.end_of_day)
    quantity_and_value = { quantity: total_quantity(todays_orders), value: total_value(todays_orders) }
  end


  def orders_days_ago(num_days_ago)
    orders = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                             .joins('JOIN products ON products.id = order_contents.product_id')
                             .where('orders.created_at BETWEEN ? AND ?', num_days_ago.day.ago.beginning_of_day, num_days_ago.day.ago.end_of_day)
    quantity_and_value = { quantity: total_quantity(orders), value: total_value(orders) }
  end


  def orders_this_week
    this_week = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                     .joins('JOIN products ON products.id = order_contents.product_id')
                     .where('orders.created_at BETWEEN ? AND ?', 1.week.ago.beginning_of_day, Date.today.end_of_day)
    quantity_and_value = { quantity: total_quantity(this_week), value: total_value(this_week) }
  end


  def orders_weeks_ago(num_weeks_ago)
    orders = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                  .joins('JOIN products ON products.id = order_contents.product_id')
                  .where('orders.created_at BETWEEN ? AND ?', num_weeks_ago.week.ago.beginning_of_day, (num_weeks_ago - 1).week.ago.end_of_day)
    quantity_and_value = { quantity: total_quantity(orders), value: total_value(orders) }
  end


  def total_quantity(orders)
    total_quantity = orders.count
  end

  def total_value(orders)
    total_value = orders.sum('order_contents.quantity * products.price').to_f
  end

end
