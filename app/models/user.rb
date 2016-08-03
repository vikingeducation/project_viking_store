class User < ActiveRecord::Base

  def self.user_count(time = nil)
    if time
      User.where("created_at > ?", time.days.ago).count
    else
      User.all.count
    end
  end

end
