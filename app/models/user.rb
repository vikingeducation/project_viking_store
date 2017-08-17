class User < ApplicationRecord
  def self.new_users(within_days)
    User.where("created_at > ? ", Time.now - within_days.days).count
  end
end
