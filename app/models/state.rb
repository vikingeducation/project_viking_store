class State < ApplicationRecord
  def self.most_lived_in(num_states)
    select('states.name, COUNT(users.billing_id) as address_count')
      .joins('JOIN addresses ON states.id = addresses.state_id')
      .joins('JOIN users ON addresses.user_id = users.id')
      .group('states.name')
      .order('address_count DESC')
      .limit(num_states)
  end
end
