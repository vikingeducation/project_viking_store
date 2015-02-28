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
end
