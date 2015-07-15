module DashboardHelper

  def get_table_headers(table_title)
    case table_title
      when 'Top User With...' then ['Item','User','Quantity']
      when 'Orders by Day' then ['Date','Quantity','Value']
      when 'Orders by Week' then ['Date','Quantity','Value']
      else ['Item','Data']
    end
  end


  def get_aggregate_data
    { 'Last 7 Days' => aggregates_by_day_range(7),
      'Last 30 Days' => aggregates_by_day_range(30),
      'Total' => aggregates_by_day_range()
    }
  end


  def get_demographic_data
    { 'Top 3 States Users Live In (billing)' => User.top_3_by_state,
      'Top 3 Cities Users Live In (billing)' => User.top_3_by_city,
      'Top User With...' => User.top_users
    }
  end


  def get_order_stats
    { 'Last 7 Days' => Order.order_stats_by_day_range(7),
      'Last 30 Days' => Order.order_stats_by_day_range(30),
      'Total' => Order.order_stats_by_day_range()
    }
  end


  def get_time_series
    { 'Orders by Day' => time_series(1),
      'Orders by Week' => time_series(7)
    }
  end



  private


  def aggregates_by_day_range(day_range = nil)
    table_data = {'New Users' => User.count_new_users(day_range),
                  'Orders' => Order.count_orders(day_range),
                  'New Products' => Product.count_new_products(day_range),
                  'Revenue' => Order.calc_revenue(day_range)
                  }

    table_data

  end


  def time_series(interval)
    output = {}

    7.times do |i|
      start_day = Time.now - (interval * i).days
      query = Order.order_stats_by_day_range(interval, start_day)

      data = [ query['Number of Orders'], query['Total Revenue'] ]

      output[start_day.to_date.to_s] = data
    end

    output
  end




end
