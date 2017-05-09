class City < ApplicationRecord

  def self.top_3_users_live_in
    select(
      "cities.name, COUNT(cities.name) AS quantity"
    ).joins(
      "JOIN addresses a ON a.city_id = cities.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group(:name).order("1 DESC").limit(3)
  end

end
