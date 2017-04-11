class DashboardController < ApplicationController

  def index
    @seven_days_users = User.seven_days_users
    @seven_days_orders = Order.seven_days_orders
    @seven_days_products = Product.seven_days_products
    @seven_days_revenue = Order.seven_days_revenue[0].sum

    @month_users = User.month_users
    @month_orders = Order.month_orders
    @month_products = Product.month_products
    @month_revenue = Order.month_revenue[0].sum

    @total_users =User.total_users
    @total_orders = Order.total_orders
    @total_products = Product.total_products
    @total_revenue = Order.total_revenue[0].sum

    @top_three_cities = User.top_three_cities
    @top_three_states = User.top_three_states









  end
end
