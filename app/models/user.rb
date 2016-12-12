class User < ApplicationRecord
  has_one :address

  def self.total_users(day_number = nil)
    day_number.nil? ? User.all.count : User.all.where(created_at: day_number.days.ago.beginning_of_day..Time.now).count
  end

end
