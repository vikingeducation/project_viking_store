class DashboardsController < ApplicationController
  def index
    @platform_analysis = platform_analysis

    # demographics
    @top_three_states = State.top_three_of_users
    @top_three_cities = City.top_three_of_users
    @highest_single_order_value = highest_single_order_value
    @highest_lifetime_value_customer = TopCustomer.highest_lifetime_value_customer
    @highest_average_order = TopCustomer.highest_average_order
    @must_orders_placed = TopCustomer.must_orders_placed

    @order_statistics = order_statistics
  end

  private

  def platform_analysis
    [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
      PlatformAnalysis.new(from_day: date)
    end
  end

  def order_statistics
    [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
      OrderStatistic.new(from_day: date)
    end
  end

  def highest_single_order_value
    TopCustomer.highest_order
  end
end
