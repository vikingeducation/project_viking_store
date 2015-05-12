class User < ActiveRecord::Base
  def self.created_since(time)
    where("created_at >= ?", time).count
  end

  def self.total
    count
  end

  def self.top_3_billing_states
    select("states.name, COUNT(*) AS total")
      .joins("JOIN addresses ON users.billing_id = addresses.id JOIN states ON addresses.state_id = states.id")
      .group('states.name')
      .order('total DESC')
      .limit(3)
  end

  def self.top_3_billing_cities
    select("cities.name, COUNT(*) AS total")
      .joins("JOIN addresses ON users.billing_id = addresses.id JOIN cities ON addresses.city_id = cities.id")
      .group('cities.name')
      .order('total DESC')
      .limit(3)
  end
end
