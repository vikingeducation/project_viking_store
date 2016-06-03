class State < ActiveRecord::Base
  has_many :addresses


  def self.top_states(n= 3)
    State.select('s.name, COUNT(*) AS total')
         .joins('AS s JOIN addresses a ON s.id = a.state_id')
         .joins('JOIN orders o ON a.id = o.billing_id')
         .where('o.checkout_date IS NOT NULL')
         .group('s.name')
         .order('total DESC')
         .limit(n)
  end
end
