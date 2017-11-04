class User < ApplicationRecord

  include CountSince

  has_many :addresses

  FIRST_ORDER_DATE = Order.select(:created_at).first

  def self.user_statistics
    user_stats_hash = {}
    user_stats_hash[:sevendays] = count_since(7.days.ago)
    user_stats_hash[:thirtydays] = count_since(30.days.ago)
    user_stats_hash[:total] = count_since(FIRST_ORDER_DATE.created_at)
    user_stats_hash
  end


end
