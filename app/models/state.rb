class State < ApplicationRecord

    belongs_to :address

  def self.three_most_populated
    # State.find_by_sql("
    #   SELECT COUNT(states.id) AS count, states.name
    #     FROM users 
    #     JOIN addresses ON users.billing_id = addresses.id 
    #     JOIN states ON addresses.state_id = states.id
    #     GROUP BY states.id
    #     ORDER BY count DESC
    #     LIMIT 3
    #     ")

    State.select("COUNT(states.id) AS count, states.name")
         .joins("JOIN addresses ON addresses.state_id = states.id JOIN users ON users.billing_id = addresses.id")
         .group("states.id")
         .order("count DESC")
         .limit(3)
  end

end
