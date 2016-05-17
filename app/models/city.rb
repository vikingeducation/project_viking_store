class City < ActiveRecord::Base
  has_many :addresses


  def self.top_cities(n= 3)
    City.select("c.name, COUNT(c.name) AS total")
        .joins('AS c JOIN addresses a ON c.id = a.city_id')
        .joins('JOIN orders o ON a.id = o.billing_id')
        .where('o.checkout_date IS NOT NULL')
        .group('c.name')
        .order('total DESC')
        .limit(n)
  end
end
