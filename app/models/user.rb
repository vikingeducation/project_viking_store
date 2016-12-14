class User < ApplicationRecord
  has_one :address
  has_one :state, through: :address


  def self.total_users(day_number = nil)
    day_number.nil? ? User.all.count : User.all.where(created_at: day_number.days.ago.beginning_of_day..Time.now).count
  end

  def self.top_states
    User.select("states.name as name, count(states.name) as state_count").joins(:address,:state).group("states.name").order("count(states.name) DESC")
  end

end
