class DashboardsController < ApplicationController
  def index
    @weekly = [Order.total(7), Product.total(7), User.total(7), OrderContent.revenue(7)]
    @monthly = [Order.total(30), Product.total(30), User.total(30), OrderContent.revenue(30)]
    @total = [Order.total, Product.total, User.total, OrderContent.revenue]

    @states_list = User.top_states
    @cities_list = User.top_cities

    @biggest_order = [OrderContent.biggest_order, OrderContent.biggest_lifetime, OrderContent.average_order, OrderContent.most_orders]
  end

end
