class User < ActiveRecord::Base

  def self.total_users
    count
  end

  def self.day_users_total(day)
    where("created_at > ? ", day.days.ago).count
  end

end
