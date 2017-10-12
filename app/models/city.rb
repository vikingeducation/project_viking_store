class City < ApplicationRecord

  def top_three_cities
    City.select(:name).joins('JOIN addresses ON cities.id = addresses.city_id')
                      .joins('JOIN orders ON orders.billing_id = addresses.id')
                      .group('cities.name').order('count(*) DESC')
                      .limit(3).count
  end

end
