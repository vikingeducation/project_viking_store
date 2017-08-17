class User < ApplicationRecord
  # calculates the number of new Users that signed up within a number of
  # days from the current day
  def self.new_users(within_days)
    User.where("created_at >= ? ", Time.now - within_days.days).count
  end
end
