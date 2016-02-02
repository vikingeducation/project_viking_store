class User < ActiveRecord::Base


  def self.last_seven_days
    User.all.where("created_at BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").count
  end

  def self.last_thirty_days
    User.all.where("created_at BETWEEN (NOW() - INTERVAL '30 days') AND NOW()").count
  end

  def self.total
    User.all.count
  end

  def self.top_three_states
    User.select("s.name, COUNT(*)").joins("AS u JOIN addresses a ON u.billing_id=a.id").joins("JOIN states s ON a.state_id=s.id").group("s.name").order("COUNT(*) DESC").limit(3)
  end
end
