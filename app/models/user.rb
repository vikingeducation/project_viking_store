class User < ActiveRecord::Base
  def self.created_since_days_ago(number)
    User.all.where('created_at >= ?', number.days.ago).count
  end
end
