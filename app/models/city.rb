class City < ApplicationRecord

  has_many :addresses

  def self.three_with_most_users
    select("cities.name AS name, COUNT(*) AS user_count").
    joins("JOIN addresses a ON cities.id = a.city_id JOIN users u ON u.billing_id = a.id").
    order("user_count DESC").
    group("cities.name").
    limit(3)
  end

end
