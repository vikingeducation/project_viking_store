class User < ActiveRecord::Base
  has_one :billing, :class_name => 'Address'
  has_one :shipping, :class_name => 'Address'
  has_many :orders
  has_many :addresses
  has_many :credit_cards

  # Returns a count of users
  # with a created_at date after the given date
  def self.count_since(date)
    User.where('created_at > ?', date).count
  end
end
