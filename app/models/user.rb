class User < ApplicationRecord
  def self.new_user_by_days(days)
    if days == 0
      sql  = "select count(*)
      from users"
    else
      sql = "select count(*)
      from users
      where created_at >= current_date - interval '" + days.to_s + " days'"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end

  def self.top_three_user_states(row, col)
    sql = "select states.name, count(*) AS count_by_star
          FROM users JOIN addresses
          ON users.billing_id = addresses.id
          JOIN states
          On addresses.state_id = states.id
          group by states.name
          order by count_by_star DESC
          limit 3"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]
  end

  def self.top_three_user_cities(row, col)
    sql = "select cities.name, count(*) AS count_by_star
          FROM users JOIN addresses
          ON users.billing_id = addresses.id
          JOIN cities
          On addresses.city_id = cities.id
          group by cities.name
          order by count_by_star DESC
          limit 3"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]
  end

end
