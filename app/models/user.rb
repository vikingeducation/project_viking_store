class User < ActiveRecord::Base

  def self.total_users 
    User.count()
  end

end
