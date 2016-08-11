class User < ActiveRecord::Base

  def self.created_last_seven_days
    User.where('created_at > ?', Time.now - 7.days)
  end

  def self.created_last_thirty_days
    User.where('created_at > ?', Time.now - 30.days)
  end
end
