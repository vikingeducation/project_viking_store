module Admin::DashboardHelper

  def present_data(data)

    unless data.is_a?(Array)
      [data]
    else
      data
    end

  end

  def currency_if_float(input)

    input.is_a?(BigDecimal) ? number_to_currency(input) : input

  end

  def get_table_headers(table_title)

    case table_title
      when 'Top User With...' then ['Item', 'User', 'Quantity']
      when 'Orders by Day' then ['Date', 'Quantity', 'Value']
      when 'Orders by Week' then ['Date', 'Quantity', 'Value']
      else ['Item', 'Data']
    end

  end

  def get_aggregate_data

    { 'Last 7 Days' => aggregates_with_range(7),
      'Last 30 Days' => aggregates_with_range(30),
      'Total' => aggregates_with_range
    }

  end

  def get_demographic_data

    { 'Top 3 States Users Live In (billing)' => User.top_3_by_state,
      'Top 3 Cities Users Live In (billing)' => User.top_3_by_city,
      'Top User With...' => User.top_users
    }

  end

  def get_order_stats

    { 'Last 7 Days' => Order.order_stats_with_range(7),
      'Last 30 Days' => Order.order_stats_with_range(30),
      'Total' => Order.order_stats_with_range
    }

  end

  def get_time_series

    { 'Orders by Day' => time_series(1),
      'Orders by Week' => time_series(7)
    }

  end

  def time_series(interval)

    # interval = 1, time series by day
    # interval = 7, time series by week
    output = {}

    7.times do |i|
      start_day = Time.now - (interval * i).days
      query = Order.order_stats_with_range(interval, start_day)

      data = [ query['Number of Orders'], query['Total Revenue'] ]

      output[start_day.to_date.to_s] = data

    end

    output

  end

  def aggregates_with_range(day_range = nil)

    table_data = { 'New Users' => User.count_new_users(day_range),
                   'Orders' => Order.count_orders(day_range),
                   'New Products' => Product.count_new_products(day_range),
                   'Revenue' => Order.calc_revenue(day_range)
                  }

    table_data

  end
  
end
