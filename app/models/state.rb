class State < ApplicationRecord
  def self.top_three_states
    State.find_by_sql("
      SELECT states.name, COUNT(users.id) as num_users FROM users
      JOIN orders on users.id = orders.user_id
      JOIN addresses on orders.billing_id = addresses.id
      JOIN states on addresses.state_id = states.id
      GROUP BY states.id
      ORDER by num_users DESC
      LIMIT 3
      ")
  end
end


