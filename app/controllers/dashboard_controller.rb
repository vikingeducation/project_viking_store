class DashboardController < ApplicationController

  def index

    @user_stats = User.new.user_statistics

    @order = Order.new
    @order_stats = @order.order_statistics
    @order_day_stats = @order.by_day_statistics
    @order_week_stats = @order.by_week_statistics
    @order_demo = @order.order_demographics


    @product_stats = Product.new.product_statistics

    @rev_stats = OrderContent.new.revenue_statistics

    @state_stats = State.new.top_three_states

    @city_stats = City.new.top_three_cities

    render 'dashboard'
    
  end


end
