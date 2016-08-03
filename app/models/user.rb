class User < ActiveRecord::Base

  def self.get_count(time = nil)
    return self.count if time.nil?
    days_ago = time.days.ago
    self.where("created_at > ?", days_ago).count
  end


  def self.get_top_three_states
    User.select("states.name, COUNT(*) as state_total").joins("JOIN addresses ON users.billing_id = addresses.id").joins("JOIN states ON states.id = addresses.state_id").group("states.name").order("state_total DESC").limit(3)
  end



    

end
