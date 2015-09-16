class User < ActiveRecord::Base

  def self.number
    return User.all.count
  end

  def self.number_in(days)
    Order.where("checkout_date > ?",Time.now - days.day).
    count
  end

  def self.top_3
    return self.find_by_sql(
      "
      SELECT   states.NAME,
      Count(users)
      FROM     users
      JOIN     addresses
      ON       users.billing_id = addresses.id
      JOIN     states
      ON       addresses.state_id = states.id
      GROUP BY states.NAME
      ORDER BY Count(users) DESC limit(3)
      "
      )
  end

  def self.ctop_3
    return self.find_by_sql(
      "
      SELECT   cities.NAME,
      Count(users)
      FROM     users
      JOIN     addresses
      ON       users.billing_id = addresses.id
      JOIN     cities
      ON       addresses.city_id = cities.id
      GROUP BY cities.NAME
      ORDER BY Count(users) DESC limit(3)
      ")
  end

    def self.top_onetime_buyer
    return self.find_by_sql(
      "
      SELECT   Concat(users.first_name,' ', users.last_name) AS NAME,
               order_contents.quantity * products.price  AS value
      FROM     users
      JOIN     orders
      ON       users.id = orders.user_id
      JOIN     order_contents
      ON       orders.id = order_contents.order_id
      JOIN     products
      ON       order_contents.product_id = products.id
      ORDER BY order_contents.quantity * products.price DESC limit(1)
      "
      )
  end

  def self.top_overall_buyer
    return self.find_by_sql(
      "
      SELECT   Concat(users.first_name,' ', users.last_name) AS NAME,
               Sum(order_contents.quantity * products.price) AS overall
      FROM     users
      JOIN     orders
      ON       users.id = orders.user_id
      JOIN     order_contents
      ON       orders.id = order_contents.order_id
      JOIN     products
      ON       order_contents.product_id = products.id
      GROUP BY Concat(users.first_name,' ', users.last_name)
      ORDER BY Sum(order_contents.quantity * products.price) DESC limit(1)
      "
      )
  end

  def self.top_avg_buyer
    return self.find_by_sql("
      SELECT   Concat(users.first_name,' ', users.last_name)  AS NAME,
               (Sum(order_contents.quantity * products.price)/Count(orders)) AS avg
      FROM     users
      JOIN     orders
      ON       users.id = orders.user_id
      JOIN     order_contents
      ON       orders.id = order_contents.order_id
      JOIN     products
      ON       order_contents.product_id = products.id
      GROUP BY Concat(users.first_name,' ', users.last_name)
      ORDER BY (Sum(order_contents.quantity * products.price)/Count(orders)) DESC limit(1)
      ")

  end

def self.top_most_buyer
    return self.find_by_sql("
      SELECT   Concat(users.first_name,' ',users.last_name) AS NAME,
      Count(orders)  AS number
      FROM     users
      JOIN     orders
      ON       users.id = orders.user_id
      GROUP BY Concat(users.first_name,' ', users.last_name)
      ORDER BY Count(orders) DESC limit(1)
      ")
end

end

