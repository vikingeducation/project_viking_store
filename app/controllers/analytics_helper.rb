class AnalyticsHelper

  def panel_one
    @overall_seven_days = {
      "New Users" => User.new_users(7),
      "Orders" =>  Order.count_recent(7),
      "Products" => Product.new_products(7),
      "Revenue" => Order.revenue_recent(7) }
    @overall_thirty_days = {
      "New Users" => User.new_users(30),
      "Orders" =>  Order.count_recent(30),
      "Products" => Product.new_products(30),
      "Revenue" => Order.revenue_recent(30)
    }
    @overall_totals = {
      "Users" => User.total,
      "Orders" => Order.orders_total,
      "Products" => Product.total,
      "Revenue" => Order.revenue_total
    }



  end








end