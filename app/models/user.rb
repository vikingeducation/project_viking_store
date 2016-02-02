class User < ActiveRecord::Base

  def self.total_users
    User.count()
  end

  def self.new_users_30
    User.where("created_at > ( CURRENT_DATE - 30 )").count
  end

end
