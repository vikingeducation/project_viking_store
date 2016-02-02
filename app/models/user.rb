class User < ActiveRecord::Base

  def self.new_users_since(start_date)
    users = User.where("created_at > '#{start_date}'").count
  end
end
