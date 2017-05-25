class City < ApplicationRecord
  has_many :addresses

    validates :name,
              presence: true,
              uniqueness: true,
              allow_blank: false,
              allow_nil: false,
              length: { maximum: 140 }

  # JOINs the cities to addresses and addresses to users, GROUPs the rows by city name, ORDERs them by user count, LIMITs the table to the first three records, and then SELECTs the city name and user count. The returned object has #city_name and #users_in_city methods.
  def self.three_with_most_users
    select("cities.name AS city_name, COUNT(*) AS users_in_city").
      joins("JOIN addresses ON cities.id = addresses.city_id JOIN users ON users.billing_id = addresses.id").
      order("users_in_city DESC").
      group("cities.name").
      limit(3)
  end
end
