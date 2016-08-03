class User < ActiveRecord::Base

  def self.total_users
    count
  end

  def self.day_users_total(day)
    where("created_at > ? ", day.days.ago).count
  end

  def self.top_states
    select("states.name, COUNT(*) AS users_in_state").joins("JOIN addresses ON (users.billing_id = addresses.id)").joins("JOIN states ON (addresses.state_id = states.id)").group("states.id").order("COUNT(*) DESC").limit(3)
  end

end
