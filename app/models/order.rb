class Order < ApplicationRecord
  ########## Methods for Orders ##########

  # finds the number of new Orders that were placed within a number of days from the current day
  def self.orders_within(days)
    Order
    .where("checkout_date IS NOT NULL")
    .where("created_at >= ?", Time.now - days.days)
    .count
  end

  # finds the total number of Orders placed across all time
  def self.total_orders
    Order.where("checkout_date IS NOT NULL").count
  end

  # finds the value of the largest Order within a number of days from the current day
  def self.largest_order_value_within(days)
    self.revenue_per_order
    .where("orders.created_at >= ?", Time.now - days.days)
    .order("revenue DESC")
    .limit(1)
    .first
    .revenue
  end

  # finds the value of the largest Order across all time
  def self.largest_order_value_across_all_time
    self.revenue_per_order
    .order("revenue DESC")
    .limit(1)
    .first
    .revenue
  end

  # determines the average Order value within a number of days from the current day
  def self.average_order_value_within(days)
    self.revenue_within(days) / self.orders_within(days)
  end

  # determines the average Order value across all time
  def self.average_order_value_across_all_time
    self.total_revenue / self.total_orders
  end

  ########## Methods for revenue ##########

  def self.base_revenue_query
    OrderContent
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .joins("JOIN products ON products.id = order_contents.product_id")
    .where("orders.checkout_date IS NOT NULL")
  end

  # calculates the total revenue across all time
  def self.total_revenue
    self.base_revenue_query
    .sum("order_contents.quantity * products.price")
  end

  # calculates the total revenue within a number of days from the current day
  def self.revenue_within(days)
    self.base_revenue_query
    .where("order_contents.created_at >= ?", Time.now - days.days)
    .sum("order_contents.quantity * products.price")
  end

  # calculates the revenue per Order.
  def self.revenue_per_order
    self.base_revenue_query
    .joins("JOIN users ON orders.user_id = users.id")
    .select("orders.id, users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS revenue")
    .group("orders.id, users.first_name, users.last_name")
  end

  # calculates the revenue for each User.
  def self.revenue_per_user
    self.base_revenue_query
    .joins("JOIN users ON orders.user_id = users.id")
    .select("users.id, users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS revenue")
    .group("users.id")
  end

  ########## Methods to find Users with highest Order value, revenue, etc ##########

  # finds the User with the most Orders placed
  def self.user_with_most_orders_placed
    Order
    .joins("JOIN users ON users.id = orders.user_id")
    .where("checkout_date IS NOT NULL")
    .select("users.first_name, users.last_name, COUNT(orders.id) AS order_count")
    .group("users.id, users.first_name, users.last_name")
    .order("order_count DESC")
    .limit(1)
    .first
  end

  # finds the User with the highest single Order value.
  def self.user_with_highest_single_order_value
    self.revenue_per_order.order("revenue DESC").limit(1).first
  end

  # finds the User with the highest lifetime revenue value.
  def self.user_with_highest_lifetime_value
    self.revenue_per_user.order("revenue DESC").limit(1).first
  end

  # finds the User with the highest average Order value.
  def self.user_with_highest_average_order_value
    OrderContent.find_by_sql(
      "
      SELECT users.first_name, users.last_name, ROUND(SUM(order_contents.quantity * products.price) / (SELECT COUNT(orders.id) FROM orders WHERE orders.checkout_date IS NOT NULL AND orders.user_id = users.id), 2) AS average_order_value
      FROM users
      JOIN orders ON orders.user_id = users.id
      JOIN order_contents ON order_contents.order_id = orders.id
      JOIN products ON products.id = order_contents.product_id
      WHERE orders.checkout_date IS NOT NULL
      GROUP BY users.id
      ORDER BY average_order_value DESC
      LIMIT 1;
      "
    ).first
  end

  ########## methods to generate time series data ##########

  # calculates the number of Orders and their value for the past 7 days
  def self.orders_by_day(num_days = 7)
    Order.find_by_sql(
      "
      SELECT DATE(dates) AS date,
      COUNT(orders.*) AS num_orders,
      COALESCE(SUM(order_contents.quantity * products.price), 0) AS value
      FROM GENERATE_SERIES((
        SELECT DATE(MIN(orders.checkout_date)) FROM orders),
        CURRENT_DATE, '1 DAY'::INTERVAL) dates
      LEFT JOIN orders ON DATE(orders.checkout_date) = dates
      LEFT JOIN order_contents ON orders.id = order_contents.order_id
      LEFT JOIN products ON products.id = order_contents.product_id
      GROUP BY dates
      ORDER BY dates DESC;
      "
    )[0..num_days - 1]
  end

  # calculates the number of Orders and their value for the past 7 weeks
  def self.orders_by_week(num_weeks = 7)
    Order.find_by_sql(
    "
    SELECT DATE(weeks) AS date,
    COUNT(orders.*) AS num_orders,
    COALESCE(SUM(order_contents.quantity * products.price), 0) AS value
    FROM GENERATE_SERIES((
      SELECT DATE(DATE_TRUNC('WEEK', MIN(orders.checkout_date))) FROM orders),
      CURRENT_DATE, '1 WEEK'::INTERVAL) weeks
    LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks
    LEFT JOIN order_contents ON orders.id = order_contents.order_id
    LEFT JOIN products ON products.id = order_contents.product_id
    GROUP BY weeks
    ORDER BY weeks DESC;
    "
    )[0..num_weeks - 1]
  end

  # formats the date of an daily Order for display in our view
  def self.format_date(date)
    case date
    when Date.today
      "Today"
    when Date.yesterday
      "Yesterday"
    else
      date.strftime('%m/%d')
    end
  end

  # formats the Orders for display in our view
  def self.format_orders(orders)
    formatted_orders = []

    orders.each do |order|
      formatted_orders.push(
        {
          date: self.format_date(order.date),
          num_orders: order.num_orders,
          value: order.value
        }
      )
    end

    formatted_orders
  end
end
