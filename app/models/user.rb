class User < ActiveRecord::Base
  def self.total
    User.all.count
  end

end
