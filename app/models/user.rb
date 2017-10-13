class User < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago

  attr_accessor :user_statistics, :user_demographics

  def user_statistics
    user_stats_hash = {}
    user_stats_hash[:sevendays] = overall_count(User, SEVEN_DAYS)
    user_stats_hash[:thirtydays] = overall_count(User, THIRTY_DAYS)
    user_stats_hash[:total] = overall_count(User, FIRST_ORDER_DATE.created_at)
    user_stats_hash
  end

  private

  def overall_count(model, num_days_ago)
    model.where('created_at >= ?', num_days_ago).count
  end


end
