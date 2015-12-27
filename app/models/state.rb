class State < ActiveRecord::Base

  def self.top_3_by_users
    User.select("s.name, COUNT(*) as count").joins(user_state_join).group("s.id").order("count DESC").limit(3)
  end

  private

  def self.user_state_join
    "JOIN addresses a ON a.id = users.billing_id JOIN states s ON s.id = a.state_id"
  end

end
