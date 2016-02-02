class DashboardController < ApplicationController

  def index
    @overall_seven_days = {
      "New Users" => User.last_seven_days,
      "Orders" =>  Order.last_seven_days,
      "Products" => Product.last_seven_days,
      "Revenue" => Order.revenue_last_seven_days }
    @overall_thirty_days = {
      "New Users" => User.last_thirty_days,
      "Orders" =>  Order.last_thirty_days,
      "Products" => Product.last_thirty_days,
      "Revenue" => Order.revenue_last_thirty_days
    }
    @overall_totals = {
      "Users" => User.total,
      "Orders" => Order.orders_total,
      "Products" => Product.total,
      "Revenue" => Order.revenue_total
    }

    # Top 3 States
    states_query = State.top_three_states
    @three_states = {}

    states_query.each do |state|
      @three_states[state.name] = state.state_count
    end

    # Top 3 Cities
    cities_query = City.top_three_cities
    @three_cities = {}

    cities_query.each do |city|
      @three_cities[city.name] = city.city_count
    end

    # Top User With...
    highest_single_order = User.highest_single_order
    highest_lifetime = User.highest_lifetime
    highest_average = User.highest_average
    most_ordered = User.most_ordered

    @data = [
      ["Item", "User", "Quantity"],
      ["Highest Single Order Value", highest_single_order.first.user, highest_single_order.first.order_value],
      ["Highest Lifetime Value", highest_lifetime.first.user, highest_lifetime.first.lifetime_total],
      ["Highest Average Order Value", highest_average.first.user, highest_average.first.avg_order_value],
      ["Most Orders Placed", most_ordered.first.user, most_ordered.first.order_count]
    ]

    @order_seven_days = {
      "Number of Orders" => @overall_seven_days["Orders"]
    }


  end

  def get
  end



end
