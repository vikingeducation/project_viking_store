class City < ActiveRecord::Base


  def self.top_three_cities
    City.select("c.name, COUNT(*) AS city_count")
         .joins("AS c JOIN addresses a ON c.id = a.city_id")
         .joins("JOIN users u ON u.billing_id = a.id")
         .group("c.name")
         .order("COUNT(*) DESC")
         .limit(3)
  end


end
