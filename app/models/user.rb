class User < ActiveRecord::Base

  def self.count_new_users(day_range = nil)
    if day_range.nil?
      User.all.count
    else
      User.where("created_at > ?", Time.now - day_range.days).count
    end
  end

end
