class User < ActiveRecord::Base

  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("created_at > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.top_states
    self.select("COUNT(*) AS user_count, states.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN states ON states.id = addresses.state_id").group("states.name").order("user_count DESC").limit(3)
  end

  def self.top_cities
    self.select("COUNT(*) AS user_count, cities.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN cities ON cities.id = addresses.city_id").group("cities.name").order("user_count DESC").limit(3)
  end

end
