class Dashboard

  def top_panels
    [ overall_platform_panel, behavior_demographics_panel ]
  end


  def bottom_panels
    [ order_statistics_panel, time_series_panel ]
  end


  private


  def overall_platform_panel
    panel = {}
    panel[:title] = "Overall Platform"
    panel[:tables] = [overall_last_seven, overall_last_thirty, overall_total]
    panel
  end


  def behavior_demographics_panel
    panel = {}
    panel[:title] = "User Demographics and Behavior"
    panel[:tables] = [top_three_states, top_three_cities, top_users]
    panel
  end

  def order_statistics_panel
    panel = {}
    panel[:title] = "Order Statistics"
    panel[:tables] = [orders_last_seven, orders_last_thirty, orders_total]
    panel
  end


  def time_series_panel
    panel = {}
    panel[:title] = "Time Series Data"
    panel[:tables] = [orders_by_day, orders_by_week]
    panel
  end


  # Overall Platform Tables
  def overall_total
    table = {}
    table[:title] = "Total"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["Users", User.total_signups]
    table[:rows] << ["Orders", Order.submitted_count]
    table[:rows] << ["Products", Product.total_listed]
    table[:rows] << ["Revenue", Order.total_revenue]
    table
  end


  def overall_last_thirty
    table = {}
    table[:title] = "Last 30 Days"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["New Users", User.total_signups(30)]
    table[:rows] << ["Orders", Order.submitted_count(30)]
    table[:rows] << ["New Products", Product.total_listed(30)]
    table[:rows] << ["Revenue", Order.total_revenue(30)]
    table
  end


  def overall_last_seven
    table = {}
    table[:title] = "Last 7 Days"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["New Users", User.total_signups(7)]
    table[:rows] << ["Orders", Order.submitted_count(7)]
    table[:rows] << ["New Products", Product.total_listed(7)]
    table[:rows] << ["Revenue", Order.total_revenue(7)]
    table
  end


  #User Behavior and Demographics Tables
  def top_three_states
    table = {}
    table[:title] = "Top 3 States Users Live In (Billing)"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    User.top_three_billing_states.each do |state|
      table[:rows] << [state.name, state.users_in_state]
    end
    table
  end


  def top_three_cities
    table = {}
    table[:title] = "Top 3 Cities Users Live In (Billing)"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    User.top_three_billing_cities.each do |city|
      table[:rows] << [city.name, city.users_in_city]
    end
    table
  end


  def top_users
    table = {}
    table[:title] = "Top Users With..."
    table[:headers] = ["Item", "User", "Quantity"]
    table[:rows] = []

    single = Order.most_expensive_order
    lifetime = Order.highest_lifetime_value
    average = Order.highest_average_order
    most = Order.most_orders_placed

    table[:rows] << [ "Highest Single Order Value", "#{single.first_name} #{single.last_name}",
                      "#{single.value}" ]
    table[:rows] << [ "Highest Lifetime Value", "#{lifetime.first_name} #{lifetime.last_name}",
                      "#{lifetime.value}" ]
    table[:rows] << [ "Highest Average Order Value", "#{average.first_name} #{average.last_name}",
                      "#{average.value}" ]
    table[:rows] << [ "Most Orders Placed", "#{most.first_name} #{most.last_name}",
                      "#{most.value}" ]

    table
  end


  #Order Statistics
  def orders_total
    table = {}
    table[:title] = "Total"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["Numer of Orders", Order.submitted_count]
    table[:rows] << ["Total Revenue", Order.total_revenue]
    table[:rows] << ["Average Order Value", Order.average_order_value]
    table[:rows] << ["Largest Order Value", Order.largest_order_value]
    table
  end


  def orders_last_thirty
    table = {}
    table[:title] = "Last 30 Days"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["Numer of Orders", Order.submitted_count(30)]
    table[:rows] << ["Total Revenue", Order.total_revenue(30)]
    table[:rows] << ["Average Order Value", Order.average_order_value(30)]
    table[:rows] << ["Largest Order Value", Order.largest_order_value(30)]
    table
  end


  def orders_last_seven
    table = {}
    table[:title] = "Last 7 Days"
    table[:headers] = ["Item", "Data"]
    table[:rows] = []
    table[:rows] << ["Numer of Orders", Order.submitted_count(7)]
    table[:rows] << ["Total Revenue", Order.total_revenue(7)]
    table[:rows] << ["Average Order Value", Order.average_order_value(7)]
    table[:rows] << ["Largest Order Value", Order.largest_order_value(7)]
    table
  end


  #Time Series Data
  def orders_by_day
    table = {}
    table[:title] = "Orders by day"
    table[:headers] = ["Date", "Quantity", "Revenue"]
    table[:rows] = []
    Order.orders_by_day(7).each do |interval|
      case interval.day
      when DateTime.now.to_date
        date = "Today"
      when DateTime.now.to_date - 1
        date = "Yesterday"
      else
        date = interval.day
      end
      table[:rows] << [date, interval.num_orders, interval.revenue]
    end
    table
  end


  def orders_by_week
    table = {}
    table[:title] = "Orders by week"
    table[:headers] = ["Date", "Quantity", "Revenue"]
    table[:rows] = []
    Order.orders_by_week(7).each do |interval|
      table[:rows] << [interval.week, interval.num_orders, interval.revenue]
    end
    table
  end

  
end