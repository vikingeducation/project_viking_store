class DashboardsController < ApplicationController
  def index
    @all_time_count = {"Users" => User.get_count,
                       "Orders" => Order.get_count,
                       "Products" => Product.get_count,
                       "Revenue" => OrderContent.get_revenue }

    @seven_days_count =   {"Users" => User.get_count(7),
                           "Orders" => Order.get_count(7),
                           "Products" => Product.get_count(7),
                           "Revenue" => OrderContent.get_revenue(7) }

    @thirty_days_count =  {"Users" => User.get_count(30),
                           "Orders" => Order.get_count(30),
                           "Products" => Product.get_count(30),
                           "Revenue" => OrderContent.get_revenue(30) }

    @popular_states = create_top_3_hash(User.get_top_states(3))
    @popular_cities = create_top_3_hash(User.get_top_cities(3))

    @top_users_with = { "Highest Single Order" => User.get_greatest_order,
                        "Hightest Lifetime Value" => User.get_lifetime_value,
                        "Highest Average Order Value" => User.highest_average_order,
                        "Most Orders Placed" => User.most_orders_placed }

    @last_seven_days = { "Number of Orders" => Order.get_count(7),
                        "Total Revenue" =>  OrderContent.get_revenue(7),
                        "Average Order Value" => OrderContent.get_average_order(7),
                        "Largest Order Value" => OrderContent.get_largest_order(7)}

    @last_thirty_days = { "Number of Orders" => Order.get_count(30),
                        "Total Revenue" =>  OrderContent.get_revenue(30),
                        "Average Order Value" => OrderContent.get_average_order(30),
                        "Largest Order Value" => OrderContent.get_largest_order(30)}

    @all_days = { "Number of Orders" => Order.get_count,
                        "Total Revenue" =>  OrderContent.get_revenue,
                        "Average Order Value" => OrderContent.get_average_order,
                        "Largest Order Value" => OrderContent.get_largest_order}


  end

  def create_top_3_hash(method)
    top_3 = method
    top_3_states = {}
    top_3.each do |state|
      top_3_states[state.name] = state.total
    end
    top_3_states
  end



end

