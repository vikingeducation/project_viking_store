class User < ActiveRecord::Base

  def self.new_users(time_period)
    User.where("created_at > ?", time_period).count
  end

  def self.in_the_last_seven_days
    self.new_users(7.days.ago)
  end

  def self.in_the_last_thirty_days
    self.new_users(30.days.ago)
  end

  def self.states_by_shipping_address
    User.select("states.name, COUNT(*) AS users_by_state").
      joins("JOIN addresses ON users.shipping_id = addresses.id JOIN states ON addresses.state_id = states.id").
      group("states.name").
      order("users_by_state DESC").
      limit(3)
  end
end
