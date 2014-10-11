class User < ActiveRecord::Base

  has_many :addresses
  has_many :orders

  def self.user(time)
    User.where('created_at > ?',time).count
  end

  def self.all_time
  	User.count
  end
end
