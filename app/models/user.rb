class User < ActiveRecord::Base

  # 1. Overall Platform

  # Last 7 Days

  def user_count(timeframe = nil)

    if timeframe.nil?
      return User.all.length
    else
      return User.where("created_at > ?", timeframe.days.ago).count
    end
  end

end
