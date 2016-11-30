module DashboardHelper
  def total_users(days_ago)
    User.all.where("created_at >  ?", 7.days.ago).count
  end

  def total_orders(days_ago)

  end

  def total_new_products(days_ago)

  end

  def total_revenue(days_ago)

  end
end
