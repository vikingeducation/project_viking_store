class City < ActiveRecord::Base

  def self.top_3_by_users
    User.select("c.name, COUNT(*) as count").joins(user_city_join).group("c.id").order("count DESC").limit(3)
  end

  private

  def self.user_city_join
    "JOIN addresses a ON a.id = users.billing_id JOIN cities c ON c.id = a.city_id"
  end

end
