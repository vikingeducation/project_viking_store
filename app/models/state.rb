class State < ActiveRecord::Base

  def self.top_three_states
    State.select("s.name, COUNT(*) AS state_count")
         .joins("AS s JOIN addresses a ON s.id = a.state_id")
         .joins("JOIN users u ON u.billing_id = a.id")
         .group("s.name")
         .order("COUNT(*) DESC")
         .limit(3)
  end



end
