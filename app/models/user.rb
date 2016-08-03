class User < ActiveRecord::Base

  def self.total_users
    self.count
  end

end
