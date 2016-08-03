class User < ActiveRecord::Base

  def user_count(time)
    User.select("COUNT(*) AS user_count").where("created_at > ?", time.days.ago)
  end

end
