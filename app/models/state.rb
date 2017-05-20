class State < ApplicationRecord

  def self.top_3_users_live_in
    select(
      "states.name, COUNT(states.name) AS quantity"
    ).joins(
      "JOIN addresses a ON a.state_id = states.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group("states.name").order("1 DESC").limit(3)
  end


end
