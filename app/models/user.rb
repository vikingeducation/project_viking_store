class User < ActiveRecord::Base
  has_many :address

  # 1. Overall Platform

  # Last 7 Days

  def user_count(timeframe = nil)

    if timeframe.nil?
      return User.all.length
    else
      return User.where("created_at > ?", timeframe.days.ago).count
    end
  end

  def top_user_states(num=3)
    User.select("COUNT(*) AS num_of_users, states.name")
        .joins("JOIN addresses ON users.billing_id=addresses.id")
        .joins("JOIN states ON addresses.state_id=states.id")
        .group("states.name")
        .order("num_of_users DESC")
        .limit(num)
  end

end
