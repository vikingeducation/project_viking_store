class Admin::DashboardController < ApplicationController

  layout "admin_portal_layout"

  def home
  end

  # def index
  #
  #   @user_stats = User.user_statistics
  #
  #   @order_stats = Order.order_statistics
  #   @order_day_stats = Order.by_day_statistics
  #   @order_week_stats = Order.by_week_statistics
  #   @order_demo = Order.order_demographics
  #
  #   @product_stats = Product.product_statistics
  #
  #   @rev_stats = OrderContent.revenue_statistics
  #
  #   @state_stats = State.top_three_states
  #
  #   @city_stats = City.top_three_cities
  #
  #   render 'dashboard'
  #
  # end

  def index
    if User.any?
      @dashboard_stats = {
        user_stats: User.user_statistics,
        order_stats: Order.order_statistics,
        order_day_stats: Order.by_day_statistics,
        order_week_stats: Order.by_week_statistics,
        order_demo: Order.order_demographics,
        product_stats: Product.product_statistics,
        rev_stats: OrderContent.revenue_statistics,
        state_stats: State.top_three_states,
        city_stats: City.top_three_cities
        }
      else
        @dashboard_stats = nil
      end
    render 'dashboard'
  end


end
