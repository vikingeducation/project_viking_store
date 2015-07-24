class DashboardController < ApplicationController

  def index
    @users = User.all
    @orders = Order.all
    @products = Product.all

    @revenue_last_30 = Order.revenue_ago(30).first.price
    @revenue_last_7 = Order.revenue_ago(7).first.price
    @revenue = Order.revenue.first.price

    @users_last_30 = User.count_last_30
    @users_last_7 = User.count_last_7

    @orders_count_last_30 = Order.count_last(30)
    @orders_count_last_7 = Order.count_last(7)

    @products_count_last_30 = Product.count_last(30)
    @products_count_last_7 = Product.count_last(7)

    @top_three_states = Order.top_state_orders 
    @top_three_cities = Order.top_city_orders
    @states_names = top_cities_states[0]
    @states_data = top_cities_states[1]

    @cities_names = top_cities_states[2]
    @cities_data = top_cities_states[3]

    @highest_single_order_value = User.highest_order_value
    @highest_lifetime_value = User.highest_lifetime_value
  end

  def top_cities_states
    state_arr = []
    city_arr = []
    state_data = []
    city_data = []
      @top_three_states.each do |state|
         state_arr <<  "#{state.name}" 
         state_data << "#{state.counter}"
      end 
      state_data << 0
    @top_three_cities.each do |city| 
        city_arr <<  "#{city.name}"
        city_data << "#{city.counter}"
     end 
    [state_arr,state_data, city_arr, city_data]
  end
end


