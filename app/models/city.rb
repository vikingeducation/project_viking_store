class City < ApplicationRecord

    validates :name, :length => { :maximum => 64 }
    belongs_to :city

  def self.three_most_populated
    # City.find_by_sql("
    #   SELECT COUNT(cities.id) AS count, cities.name
    #     FROM users 
    #     JOIN addresses ON users.billing_id = addresses.id 
    #     JOIN cities ON addresses.state_id = cities.id
    #     GROUP BY cities.id
    #     ORDER BY count DESC
    #     LIMIT 3
    #     ")

    City.select("COUNT(cities.id) AS count, cities.name")
         .joins("JOIN addresses ON addresses.state_id = cities.id JOIN users ON users.billing_id = addresses.id")
         .group("cities.id")
         .order("count DESC")
         .limit(3)
  end

end
