class User < ActiveRecord::Base

  def self.new_users_since(start_date)
    users = User.where("created_at > '#{start_date}'").count
  end

  def self.total_users
    User.all.count
  end

  # def top_user_states
  #   Address.select("state_id").where("id IN (User.billing_id) ").group(state_id).count
  # end
  #want to return a table of state counts desc, top 3
end
