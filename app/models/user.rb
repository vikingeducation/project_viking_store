class User < ApplicationRecord
  has_one :address

  def total_users(last_date = nil)
    last_date.nil? ? User.count : User.where(created_at: last_date..Date.today).count
  end

end
