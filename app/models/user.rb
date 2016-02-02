class User < ActiveRecord::Base


  def self.last_seven_days
    User.all.where("created_at BETWEEN (NOW() - INTERVAL 7 DAY) AND NOW()").count
  end



end
