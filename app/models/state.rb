class State < ActiveRecord::Base
  has_many :addresses

  def self.three_with_most_users
    select("states.name AS state_name, COUNT(*) AS users_in_state").
      joins("JOIN addresses ON states.id = addresses.state_id JOIN users ON users.billing_id = addresses.id").
      order("users_in_state DESC").
      group("states.name").
      limit(3)
  end
end
