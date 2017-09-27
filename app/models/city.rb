class City < ApplicationRecord
  MAX_NAME_LENGTH = 64

  validates :name,
            presence: true,
            length: { maximum: MAX_NAME_LENGTH }

  # determines the top 3 Cities that Users live in by billing address
  def self.top_3_cities_by_billing_address
    City
    .select("cities.name, COUNT(cities.name)")
    .joins("JOIN addresses ON addresses.city_id = cities.id")
    .joins("JOIN users ON users.billing_id = addresses.id")
    .group("cities.name")
    .order("COUNT(cities.name) DESC")
    .limit(3)
  end
end
