class User < ActiveRecord::Base

  def user_count(days)
    User.where("created_at > ?", time.days.ago)
  end

end
