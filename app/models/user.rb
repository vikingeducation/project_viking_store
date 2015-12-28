class User < ActiveRecord::Base
  scope :day_range, -> (start_day, end_day) {where("created_at >= ? AND created_at <= ?", start_day.days.ago, end_day.days.ago)}

  private

  # Join clause to join users with order_totals table
  def self.user_order_totals_join(days_ago = nil)
    "JOIN (#{Order.order_totals_query(days_ago)}) ot ON ot.user_id = users.id"
  end

  # Returns first_name, last_name, revenue for each order
  def self.user_order_totals(days_ago = nil)
    User.select("users.first_name, users.last_name, ot.revenue as amount").joins(user_order_totals_join)
  end

  def self.get_highest_order_user
    user_order_totals.order("amount DESC").limit(1)[0]
  end

  def self.get_highest_aggregation_user(aggregator)
    User.select("users.first_name, users.last_name, #{aggregator}(ot.revenue) as amount").joins(user_order_totals_join).group("users.id").order("amount DESC").limit(1)[0]
  end

end
