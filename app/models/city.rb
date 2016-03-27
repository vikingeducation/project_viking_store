class City < ActiveRecord::Base
  # If you deleted a city would you destroy an address? I don't think so but I don't like the idea of having an address with a null value for it's city but that's more of a general design issue.
  has_many :addresses, :dependent => :nullify

  def self.top_three_cities
    # Trying to find via find_by_sql
    # First I needed a subquery table that got me all the distinct user_ids and one billing_id attached to each.
    # Then I joined it with the addresses table and the cities tables.
    # I did a GOUP BY cities.name so that I could get a count of each state
    # Then I ordered the aggregate 'count(*)' of those cities descending
    # Then I sorted those descending
    # Then I got the top 3.
    # Use this method by:
    # ...first.name #=> 'Texas'  ...first.total #=> 4
    City.find_by_sql("SELECT cities.name, COUNT(*) AS total 
                      FROM (SELECT user_id, MAX(billing_id) as billing_id FROM orders GROUP BY user_id) 
                        AS a
                      JOIN addresses
                        ON a.billing_id=addresses.id 
                      JOIN cities 
                        ON addresses.city_id=cities.id 
                      GROUP BY cities.name 
                      ORDER BY total DESC 
                      LIMIT 3")
  end
end
