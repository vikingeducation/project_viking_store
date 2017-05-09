module DashboardHelper

  def one_total
    [
      ["New Users", User.count],
      ["Orders", Order.count],
      ["New Products", Product.count],
      ["Revenue", OrderContent.total_revenue]
    ]
  end

  def one_seven_days
    [
      ["New Users", User.where("created_at > ?", Time.now - 7.minute).count],
      ["Orders", Order.where("created_at > ?", Time.now - 7.day).count],
      ["New Products", Product.where("created_at > ?", Time.now - 7.day).count],
      ["Revenue", OrderContent.revenue_since(Time.now - 7.day)]
    ]
  end

  def one_thirty_days
    [
      ["New Users", User.where("created_at > ?", Time.now - 30.day).count],
      ["Orders", Order.where("created_at > ?", Time.now - 30.day).count],
      ["New Products", Product.where("created_at > ?", Time.now - 30.day).count],
      ["Revenue", OrderContent.revenue_since(Time.now - 30.day)]
    ]
  end

  def two_states
    r = State.top_3_users_live_in
    r.map{ |state| [state.name, state.quantity] }
  end

  def two_cities
    r = City.top_3_users_live_in
    r.map{ |city| [city.name, city.quantity] }
  end

  def three_highest_order_value
    r = Order.highest_value
    ["Highest Order Value", r.customer_name, r.quantity]
  end

  def three_lifetime_value
    r = Order.highest_lifetime_value
    ["Highest Lifetime Value", r.customer_name, r.quantity]
  end

  def three_highest_avg_order_value
    r = Order.highest_average_value
    ["Highest Average Order Value", r.customer_name, r.quantity]
  end

  def three_most_orders_placed
    r = Order.most_orders_placed
    ["Most Orders Placed", r.customer_name, r.quantity]
  end

  def top_user_with
    [
      three_highest_order_value,
      three_lifetime_value,
      three_highest_avg_order_value,
      three_most_orders_placed
    ]
  end

  def three_total
    [
      {:column_name => "Orders", :data => Order.count},
      {:column_name => "Revenue", :data => OrderContent.total_revenue},
      {:column_name => "Average Order Value", :data => Order.average_value.to_i},
      {:column_name => "Largest Order Value", :data => Order.highest_value[:quantity]}
    ]
  end

  def three_thirty_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "Revenue", :data => OrderContent.revenue_since(Time.now - 30.day)},
      {:column_name => "Average Order Value",
       :data => Order.average_value_since(Time.now - 30.day).to_i},
      {:column_name => "Largest Order Value",
       :data => Order.highest_value_since(Time.now - 30.day)[:quantity]}
    ]
  end

  def three_seven_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 7.day).count},
      {:column_name => "Revenue",
       :data => OrderContent.revenue_since(Time.now - 7.day)},
      {:column_name => "Average Order Value",
       :data => Order.average_value_since(Time.now - 7.day).to_i},
      {:column_name => "Largest Order Value",
       :data => Order.highest_value_since(Time.now - 7.day)[:quantity]}
    ]
  end

end
