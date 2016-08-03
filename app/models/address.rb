class Address < ActiveRecord::Base

  class << self

    def top_three_states
      Address.find_by_sql(
        "SELECT states.name, COUNT(*) as num_from_each_state FROM addresses JOIN users ON addresses.id = users.billing_id JOIN states ON addresses.state_id = states.id GROUP BY states.name ORDER BY num_from_each_state DESC LIMIT 3").to_a
    end

    def top_three_cities
      Address.find_by_sql(
        "SELECT cities.name, COUNT(*) as num_from_each_city FROM addresses JOIN users ON addresses.id = users.billing_id JOIN cities ON addresses.city_id = cities.id GROUP BY cities.name ORDER BY num_from_each_city DESC LIMIT 3").to_a
    end

  end

end

