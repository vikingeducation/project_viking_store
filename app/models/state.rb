class State < ActiveRecord::Base

  def self.top_3_summary
    user_name_query = "SELECT user_name FROM (#{top_user}) us WHERE us.id = top.id"

    query = "SELECT top.id, top.name, top.count, (#{user_name_query}) as user_name FROM (#{top_3_by_users}) top"

    State.find_by_sql(query)
  end

  # Returns state id, state name, and user count
  def self.top_3_by_users
    "
      SELECT s.id, s.name, COUNT(u.id) as count
      FROM users u
        JOIN addresses a ON a.id = u.billing_id
        JOIN states s ON s.id = a.state_id
      GROUP BY s.id
      ORDER BY count DESC
      LIMIT 3"
  end

  # Returns state id, user name, and total revenue for the user where the top.id (state id) is equivalent
  def self.top_user
    ot = Order.order_totals_query

    "
      SELECT s.id, CONCAT(u.first_name, ' ', u.last_name) as user_name, SUM(ot.revenue) as total_revenue
      FROM users u
        JOIN (#{ot}) ot ON ot.user_id = u.id
        JOIN addresses a ON a.id = u.billing_id
        JOIN states s ON s.id = a.state_id
        WHERE s.id = top.id
      GROUP BY u.id, s.id
      ORDER BY total_revenue DESC
      LIMIT 1
      "
  end

end
