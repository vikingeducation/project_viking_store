module Admin
  class DashboardsController < ApplicationController
    def index
      @platform = platform

      # demographics
      @top_states = State.three_with_most_users
      @top_cities = City.three_with_most_users

      # top customers
      @top_customers = Admin::Analysis::TopCustomer.all

      @order_statistics = order_statistics
      @orders_by_day = OrderTimeSeries.orders_by_day
      @orders_by_week = OrderTimeSeries.orders_by_week
    end

    private

    def platform
      [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
        Admin::Analysis::Platform.new(from_day: date)
      end
    end

    def order_statistics
      [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
        OrderStatistic.new(from_day: date)
      end
    end
  end
end
