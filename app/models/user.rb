class User < ActiveRecord::Base

  def self.total_users
    User.count()
  end

  def self.new_users_in_last_n_days( n )
    User.where("created_at > ( CURRENT_DATE - #{n} )").count
  end

end
