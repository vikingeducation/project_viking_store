module DashboardsHelper

# Panel 1: Overall Platform
  def metrics(num_days=nil)
    {
      "User" => User.total(num_days),
      "Order" => Order.total(num_days),
      "Product" => Product.total(num_days),
      "Revenue" => revenue(num_days)
      }
  end

  def revenue(num_days=nil)
    revenue = Order.total_revenue
    if num_days
      revenue.where("checkout_date <= ?", num_days.days.ago)[0].sum
    else
      revenue[0].sum
    end
  end

# Panel 3: Order Stats
  def order_stats(num_days=nil)
    {
      "Number of Orders" => Order.total(num_days),
      "Total Revenue" => revenue(num_days),
      "Average Order Value" => Order.highest_average_order_value(num_days)[0].avg_order_value,
      "Largest Order Value" => Order.largest_order_value(num_days)[0].order_value
      }
  end

end
