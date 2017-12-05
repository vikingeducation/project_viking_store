class Address < ApplicationRecord

  belongs_to :user
  belongs_to :order
  belongs_to :city
  belongs_to :state

  def self.top_3_states
    sql = "
    SELECT s.name, COUNT(s.name) AS user_count
    FROM addresses a
    JOIN states s ON a.state_id = s.id
    JOIN users u ON a.id = u.billing_id
    GROUP BY s.name
    ORDER BY user_count DESC
    LIMIT 3
    "
    self.find_by_sql(sql)
  end

  def self.top_3_cities
    sql = "
    SELECT c.name, COUNT(c.name) AS user_count
    FROM addresses a
    JOIN cities c ON a.city_id = c.id
    JOIN users u ON a.id = u.billing_id
    GROUP BY c.name
    ORDER BY user_count DESC
    LIMIT 3
    "
    self.find_by_sql(sql)
  end

end
