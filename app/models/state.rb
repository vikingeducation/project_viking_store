class State < ApplicationRecord
  def self.top_states
    State.select("states.name, COUNT(states.name) AS users_sum").joins("JOIN addresses ON states.id = addresses.state_id").joins("
    JOIN users ON addresses.id = users.billing_id").group("
    states.name").order("
    COUNT(states.name) DESC").limit(3)
  end
end
