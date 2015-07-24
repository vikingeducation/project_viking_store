class State < ActiveRecord::Base

  def self.get_top_states
    result = []
    table = User.joins("JOIN addresses ON users.billing_id = addresses.id")
    top_states = table.select("addresses.state_id, count(*) AS users").group("addresses.state_id").order("users desc").limit(3)
    table = top_states.joins("JOIN states ON state_id = states.id")
    table.select("states.name")
    result = [
          [table.select("states.name").first[:name], table.select("states.name").first[:users]],
          [table.select("states.name").second[:name], table.select("states.name").second[:users]],
          [table.select("states.name").third[:name], table.select("states.name").third[:users]]
        ]
  end
  
end
