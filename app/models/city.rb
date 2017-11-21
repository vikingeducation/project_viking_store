class City < ApplicationRecord

  has_many :addresses

  def self.top_three_cities
    City.select(:name).joins(:addresses).
                      group('cities.name').
                      order("count(cities.name) DESC").
                      limit(3).
                      count
  end

end
