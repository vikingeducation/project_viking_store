class User < ActiveRecord::Base

  def self.new_users(num_days)
    User.where("created_at >= ? ", num_days.days.ago)
  end
end
