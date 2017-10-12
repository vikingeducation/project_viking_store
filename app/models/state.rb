class State < ApplicationRecord

  def top_three_states
    State.select(:name).joins('JOIN addresses ON states.id = addresses.state_id')
                       .joins('JOIN orders ON orders.billing_id = addresses.id')
                       .group('states.name').order('count(*) DESC')
                       .limit(3).count
  end
  
end
