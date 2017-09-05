class State < ApplicationRecord
  def to_s
    StatesHelper::STATE_POSTAL_CODES.key(self.name)
  end

  # determines the top 3 States that Users live in by billing address
  def self.top_3_states_by_billing_address
    State
    .select("states.name, COUNT(states.name)")
    .joins("JOIN addresses ON addresses.state_id = states.id")
    .joins("JOIN users ON users.billing_id = addresses.id")
    .group("states.name")
    .order("COUNT(states.name) DESC")
    .limit(3)
  end
end
