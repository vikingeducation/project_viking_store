class City < ApplicationRecord
  def self.most_lived_in(num_cities)
    select('cities.name, COUNT(users.billing_id) as address_count')
      .joins('JOIN addresses ON cities.id = addresses.city_id')
      .joins('JOIN users ON addresses.user_id = users.id')
      .group('cities.name')
      .order('address_count DESC')
      .limit(num_cities)
  end
end
