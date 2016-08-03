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
    @popular_states = create_top_3_hash(User.get_top_three_states)


                       

  end

  def create_top_3_hash(method)
    top_3 = method
    top_3_states = {}
    top_3.each do |state|
      top_3_states[state.name] = state.state_total
    end
    top_3_states
  end



end

