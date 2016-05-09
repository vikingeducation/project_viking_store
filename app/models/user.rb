class User < ActiveRecord::Base
  def self.total
    User.all.count
  end

  def self.new_users(t)
    User.where("created_at > ?", Time.now- t*24*60*60).count
  end

end
