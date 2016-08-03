class Address < ActiveRecord::Base

  def self.top_states(num = 3)
    Address.select("states.name,COUNT(*) AS state_count").joins("JOIN users ON users.billing_id=addresses.id").joins("JOIN states ON addresses.state_id=states.id").group("states.name").order("state_count DESC").limit(num).to_a
  end

  def self.top_cities(num = 3)
    Address.select("cities.name,COUNT(*) AS city_count").joins("JOIN users ON users.billing_id=addresses.id").joins("JOIN cities ON addresses.city_id=cities.id").group("cities.name").order("city_count DESC").limit(num).to_a
  end
end