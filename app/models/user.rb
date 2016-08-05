class User < ActiveRecord::Base

  def self.total_users
    count
  end

  def self.day_users_total(day)
    where("created_at > ? ", day.days.ago).count
  end

  def self.top_states
    select("states.name, COUNT(*) AS users_in_state")
    .joins("JOIN addresses ON (users.billing_id = addresses.id)")
    .joins("JOIN states ON (addresses.state_id = states.id)")
    .group("states.id").order("COUNT(*) DESC").limit(3)
  end

  def self.top_cities
    select("cities.name, COUNT(*) AS users_in_city")
    .joins("JOIN addresses ON (users.billing_id = addresses.id)")
    .joins("JOIN cities ON (addresses.state_id = cities.id)")
    .group("cities.id").order("COUNT(*) DESC").limit(3)
  end

#highest lifetime value
#highest avg value
#most orders

  def self.join_products_get_order_totals
    select("CONCAT(users.first_name, ' ', users.last_name) AS full_name, SUM(products.price * order_contents.quantity) AS order_total")
    .joins("JOIN orders ON (users.id = orders.user_id)")
    .joins("JOIN order_contents ON (orders.id = order_contents.order_id)")
    .joins("JOIN products ON (products.id = order_contents.product_id)")
    .where("checkout_date IS NOT NULL")
  end

  def self.get_all_orders_highest_first
    join_products_get_order_totals
    .group("orders.id, users.first_name, users.last_name")
    .order("order_total DESC")
  end

  def self.highest_lifetime_value
    join_products_get_order_totals
    .group("users.id, users.first_name, users.last_name")
    .order("order_total DESC")
  end

  def self.highest_avg_order
    select("subquery.full_name, AVG(subquery.order_total) AS order_average")
      .from(get_all_orders_highest_first)
      .group("subquery.full_name")
      .order("order_average DESC")

    # find_by_sql("
    #   SELECT full_name, SUM(order_total)/COUNT(order_total) AS order_average
    #   FROM ( SELECT CONCAT(users.first_name, ' ', users.last_name) AS full_name, SUM(products.price * order_contents.quantity) AS order_total
    #     FROM users JOIN orders ON (users.id = orders.user_id)
    #     JOIN order_contents ON (orders.id = order_contents.order_id)
    #     JOIN products ON (products.id = order_contents.product_id)
    #     WHERE checkout_date IS NOT NULL
    #     GROUP BY orders.id, users.first_name, users.last_name
    #     ) AS order_sum
    #     GROUP BY full_name
    #     ORDER BY order_average DESC")
  end

  def self.most_orders_placed
    # find_by_sql("
    #   SELECT full_name, COUNT(order_total) AS orders
    #   FROM ( SELECT CONCAT(users.first_name, ' ', users.last_name) AS full_name, SUM(products.price * order_contents.quantity) AS order_total
    #     FROM users JOIN orders ON (users.id = orders.user_id)
    #     JOIN order_contents ON (orders.id = order_contents.order_id)
    #     JOIN products ON (products.id = order_contents.product_id)
    #     WHERE checkout_date IS NOT NULL
    #     GROUP BY orders.id, users.first_name, users.last_name
    #     ) AS order_sum
    #     GROUP BY full_name
    #     ORDER BY orders DESC")

    select("subquery.full_name, COUNT(subquery.order_total) AS orders")
        .from(get_all_orders_highest_first)
        .group("subquery.full_name")
        .order("orders DESC")
  end

end
