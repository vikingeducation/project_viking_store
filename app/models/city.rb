class City < ApplicationRecord

  def top_three_cities
    City.select(:name).join_addresses_onto_cities
                      .join_orders_onto_addresses
                      .group_top_three('cities.name')
  end


  private


  def join_addresses_onto_cities
    joins('JOIN addresses ON cities.id = addresses.city_id')
  end

end
