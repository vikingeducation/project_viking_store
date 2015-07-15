module DashboardHelper

  def get_aggregate_data
    { 'Last 7 Days' => aggregates_by_day_range(7),
      'Last 30 Days' => aggregates_by_day_range(30),
      'Total' => aggregates_by_day_range()
    }
  end


  def get_demographic_data
    { 'Top 3 States Users Live In (billing)' => User.top_3_by_state,
      'Top 3 Cities Users Live In (billing)' => User.top_3_by_city
    }
  end



  private


  def aggregates_by_day_range(day_range = nil)
    { 'New Users' => User.count_new_users(day_range),
      'Orders' => Order.count_orders(day_range),
      'New Products' => Product.count_new_products(day_range),
      'Revenue' => Order.calc_revenue(day_range)
    }
  end




end
