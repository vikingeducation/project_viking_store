class City < ApplicationRecord


  def top_three_cities
    City.select(:name).joins_addresses_onto_cities.
                      joins_orders_onto_addresses.
                      group('cities.name').
                      order("count(cities.name) DESC").
                      limit(3).
                      count
  end


  private

  def self.joins_addresses_onto_cities
    joins('JOIN addresses ON cities.id = addresses.city_id')
  end

  def self.joins_orders_onto_addresses
    joins('JOIN orders ON orders.billing_id = addresses.id')
  end

end
