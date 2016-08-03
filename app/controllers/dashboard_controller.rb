class DashboardController < ApplicationController
  def show
    @aggregates = {
      last_seven_days: {
        users: User.last_seven_days,
        orders: Order.last_seven_days,
        products: Product.last_seven_days,
        revenue: Order.revenue_last_seven_days 
      },
      last_thirty_days: {
        users: User.last_thirty_days,
        orders: Order.last_thirty_days,
        products: Product.last_thirty_days,
        revenue: Order.revenue_last_thirty_days 
      }
    }
    
    @demographics = {
      top_three_states: Address.top_three_states,
      top_three_cities: Address.top_three_cities,
      top_users_with: {
        "Highest Single Order Value" => OrderContent.highest_single_order_value,
        "Highest Lifetime Value" => OrderContent.highest_lifetime_value,
        "Highest Average Value" => OrderContent.highest_average_value,
        "Most Orders Placed" => OrderContent.most_orders_placed
      }
    }
  end
end
