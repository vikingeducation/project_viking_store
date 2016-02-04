class Order < ActiveRecord::Base
  def self.total_orders_submitted
    Order.where( "checkout_date IS NOT NULL" ).count()
  end

  def self.total_revenue_generated
    join_with_products.where(
    "orders.checkout_date IS NOT NULL"
    ).sum(
    "products.price * order_contents.quantity"
    )
  end

  def self.num_orders_submitted_in_last_n_days( n )
    Order.where( str_orders_submitted_in_last_n_days( n )).count()
  end

  def self.str_orders_submitted_in_last_n_days( n )
    "checkout_date IS NOT NULL AND checkout_date > ( CURRENT_DATE - #{n} ) "
  end

  def self.revenue_n_days( n )
    join_with_products.where(
    str_orders_submitted_in_last_n_days( n )
    ).sum(
    "products.price * order_contents.quantity"
    )
  end

  def self.str_orders_submitted_n_days_ago( n )    # n == 0 implies today
    "checkout_date IS NOT NULL AND DATE_TRUNC('day', checkout_date) = DATE_TRUNC( 'day', CURRENT_DATE - #{n} ) "
  end

  def self.revenue_n_days_ago( n )  # n == 0 implies today
    join_with_products
    .where(
    str_orders_submitted_n_days_ago( n )
    ).sum(
    "products.price * order_contents.quantity"
    )
  end

  def self.num_orders_n_days_ago( n )  # n == 0 implies today
    join_with_products
    .where(
    str_orders_submitted_n_days_ago( n )
    ).count
  end

  def self.str_orders_submitted_n_weeks_ago( n )
    "checkout_date IS NOT NULL AND DATE_TRUNC('week', checkout_date) = DATE_TRUNC( 'week', CURRENT_DATE - 7 * #{n} ) "
  end

  def self.num_orders_n_weeks_ago( n )
    join_with_products
    .where( str_orders_submitted_n_weeks_ago( n ))
    .count
  end

  def self.num_orders_past_n_days(n)
    order_arr = []
    (0...n).each do |num|
      order_arr[num] = num_orders_n_days_ago( num )
    end
    order_arr
  end

  def self.num_orders_past_n_weeks(n)
    order_arr = []
    (0...n).each do |num|
      order_arr[num] = num_orders_n_weeks_ago( num )
    end
    order_arr
  end

  def self.revenue_n_weeks_ago( n )
    join_with_products
    .where( str_orders_submitted_n_weeks_ago( n ))
    .sum( "products.price * order_contents.quantity" )
  end

  def self.revenue_past_n_days(n)
    rev_arr = []
    (0...n).each do |num|
      rev_arr[num] = revenue_n_days_ago( num )
    end
    rev_arr
  end

  def self.revenue_past_n_weeks(n)
    rev_arr = []
    (0...n).each do |num|
      rev_arr[num] = revenue_n_weeks_ago( num )
    end
    rev_arr
  end

  def self.largest_order
    join_with_products.select( "orders.id, MAX( products.price * order_contents.quantity ) AS largest_order ").group( "orders.id" ).order("largest_order DESC").limit(1)
  end

  def self.largest_order_last_n_days( n )
    join_with_products.select( "orders.id, MAX( products.price * order_contents.quantity ) AS largest_order ")
    .where( str_orders_submitted_in_last_n_days( n ))
    .group( "orders.id" ).order("largest_order DESC").limit(1)
  end

  def self.average_order
    join_with_products.select( "AVG( products.price * order_contents.quantity ) AS average_order")
  end

  def self.average_order_last_n_days( n )
    join_with_products.select( "AVG( products.price * order_contents.quantity ) AS average_order")
    .where( str_orders_submitted_in_last_n_days( n ))
  end

  def self.join_with_products
    Order.joins(
      "JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id"
      )
  end

end
