class City < ActiveRecord::Base
  has_many :addresses

  validates :name, length: { maximum: 64 }


  def self.three_with_most_users
    select("cities.name AS city_name, COUNT(*) AS users_in_city").
      joins("JOIN addresses ON cities.id = addresses.city_id JOIN users ON users.billing_id = addresses.id").
      order("users_in_city DESC").
      group("cities.name").
      limit(3)
  end
end
