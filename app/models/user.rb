class User < ActiveRecord::Base

  def self.count_new_users(day_range = nil)
    if day_range.nil?
      User.all.count
    else
      User.where("created_at > ?", Time.now - day_range.days).count
    end
  end


  def self.top_3_by_state
    User.joins("JOIN addresses ON users.billing_id = addresses.id
                JOIN states ON addresses.state_id = states.id").
          group("states.name").
          order("count(distinct users.id) DESC").limit(3).
          count(:id)
  end


  def self.top_3_by_city
    User.joins("JOIN addresses ON users.billing_id = addresses.id
                JOIN cities ON addresses.city_id = cities.id").
          group("cities.name").
          order("count(distinct users.id) DESC").limit(3).
          count(:id)
  end

end
