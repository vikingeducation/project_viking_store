class DashboardController < ApplicationController
  include DashboardHelper

  def index

    @one = {
      :total => one_total,
      :thirty_days => one_thirty_days,
      :seven_days => one_seven_days
    }

    @two = {
      :states => two_states,
      :cities => two_cities,
      :top_user_with => top_user_with
    }

    @three = {
      :total => three_total,
      :thirty_days => three_thirty_days,
      :seven_days => three_seven_days
    }
  end

  def two_states
    r = top_3_states_users_live
    r.map{ |state| [state.name, state.quantity] }
  end

  def two_cities
    r = top_3_cities_users_live
    r.map{ |city| [city.name, city.quantity] }
  end

  # ------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------

  def one_total
    [
      ["New Users", User.count],
      ["Orders", Order.count],
      ["New Products", Product.count],
      ["Revenue", total_revenue]
    ]
  end

  def one_seven_days
    [
      ["New Users", User.where("created_at > ?", Time.now - 7.minute).count],
      ["Orders", Order.where("created_at > ?", Time.now - 7.day).count],
      ["New Products", Product.where("created_at > ?", Time.now - 7.day).count],
      ["Revenue", revenue_since(Time.now - 7.day)]
    ]
  end

  def one_thirty_days
    [
      ["New Users", User.where("created_at > ?", Time.now - 30.day).count],
      ["Orders", Order.where("created_at > ?", Time.now - 30.day).count],
      ["New Products", Product.where("created_at > ?", Time.now - 30.day).count],
      ["Revenue", revenue_since(Time.now - 30.day)]
    ]
  end

  def top_user_with
    [
      highest_order_value,
      highest_lifetime_value,
      highest_average_order_value,
      most_orders_placed
    ]
  end

  def three_total
    [
      {:column_name => "Orders", :data => Order.count},
      {:column_name => "Revenue", :data => total_revenue},
      {:column_name => "Average Order Value", :data => average_order_value.to_i},
      {:column_name => "Largest Order Value", :data => highest_order_value[:quantity]}
    ]
  end

  def three_thirty_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "Revenue", :data => revenue_since(Time.now - 30.day)},
      {:column_name => "Average Order Value",
       :data => avg_order_value_since(Time.now - 30.day).to_i},
      {:column_name => "Largest Order Value",
       :data => highest_order_value_since(Time.now - 30.day)[:quantity]}
    ]
  end

  def three_seven_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 7.day).count},
      {:column_name => "Revenue",
       :data => revenue_since(Time.now - 7.day)},
      {:column_name => "Average Order Value",
       :data => avg_order_value_since(Time.now - 7.day).to_i},
      {:column_name => "Largest Order Value",
       :data => highest_order_value_since(Time.now - 7.day)[:quantity]}
    ]
  end

end
