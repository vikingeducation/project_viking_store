class User < ActiveRecord::Base

  has_one :credit_card
  has_many :addresses
  has_many :orders

  def self.created_since_days_ago(number)
    User.all.where('created_at >= ?', number.days.ago).count
  end
end
