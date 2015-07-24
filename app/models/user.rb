class User < ActiveRecord::Base

  def self.count_last_30
    User.where("created_at > ?", 30.days.ago).count
  end

  def self.count_last_7
    User.where("created_at > ?", 7.days.ago).count
  end
end
