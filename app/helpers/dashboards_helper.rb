module DashboardsHelper

  # Queries for Panel 1: Overall Platform
  def metrics(num_days=nil)
    {
      "User" => user_count(num_days),
      "Order" => order_count(num_days),
      "Product" => product_count(num_days),
      "Revenue" => revenue(num_days)
      }
  end

  def user_count(num_days=nil)
    if num_days
      User.where("created_at > ?", num_days.days.ago).count
    else
      User.count
    end
  end

  def order_count(num_days=nil)
    if num_days
      Order.where("created_at > ?", num_days.days.ago).count
    else
      Order.count
    end
  end

  def product_count(num_days=nil)
    if num_days
      User.where("created_at > ?", num_days.days.ago).count
    else
      User.count
    end
  end

  def revenue(num_days=nil)
    revenue = Order.total_revenue
    if num_days
      revenue.where("checkout_date <= ?", num_days.days.ago)[0].sum
    else
      revenue[0].sum
    end
  end

  # Queries for Panel 1: Overall Platform

end
