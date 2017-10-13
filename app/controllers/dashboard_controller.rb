class DashboardController < ApplicationController


  def index
    @user = User.new
    @user_stats = @user.user_statistics

    @order = Order.new
    @order_stats = @order.order_statistics
    @order_day_stats = @order.by_day_statistics
    @order_week_stats = @order.by_week_statistics
    @order_demo = @order.order_demographics


    @product = Product.new
    @product_stats = @product.product_statistics

    @revenue = OrderContent.new
    @rev_stats = @revenue.revenue_statistics

    @state = State.new
    @state_stats = @state.top_three_states

    @city = City.new
    @city_stats = @city.top_three_cities

    render 'dashboard'
  end


end
