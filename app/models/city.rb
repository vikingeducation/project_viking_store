class City < ActiveRecord::Base
  has_many :addresses

  def self.top_3_summary
    user_name_query = "SELECT user_name FROM (#{top_user}) uc WHERE uc.id = top.id"

    query = "SELECT top.id, top.name, top.count, (#{user_name_query}) as user_name FROM (#{top_3_by_users}) top"

    City.find_by_sql(query)
  end

  # Returns city id, city name, and user count
  def self.top_3_by_users
    "
      SELECT c.id, c.name, COUNT(u.id) as count
      FROM users u
        JOIN addresses a ON a.id = u.billing_id
        JOIN cities c ON c.id = a.city_id
      GROUP BY c.id
      ORDER BY count DESC
      LIMIT 3"
  end

  # Returns city id, user name, and total revenue for the user where the top.id (city id) is equivalent
  def self.top_user
    ot = Order.order_totals_query

    "
      SELECT c.id, CONCAT(u.first_name, ' ', u.last_name) as user_name, SUM(ot.revenue) as total_revenue
      FROM users u
        JOIN (#{ot}) ot ON ot.user_id = u.id
        JOIN addresses a ON a.id = u.billing_id
        JOIN cities c ON c.id = a.city_id
        WHERE c.id = top.id
      GROUP BY u.id, c.id
      ORDER BY total_revenue DESC
      LIMIT 1
      "
  end

end
