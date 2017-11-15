module Admin
  class DashboardsController < ApplicationController
    def index
      @platform = Admin::Analysis::Platform.
                    from(7.days.ago, 30.days.ago, Time.at(0))

      # demographics
      @top_states = State.three_with_most_users
      @top_cities = City.three_with_most_users

      # top customers
      @top_customers = Admin::Analysis::TopCustomer.all

      @order_statistics = Admin::Analysis::OrderStatistic.from(7.days.ago, 30.days.ago, Time.at(0))
      @orders_by_day = Admin::Analysis::OrderTimeSeries.orders_by_day
      @orders_by_week = Admin::Analysis::OrderTimeSeries.orders_by_week
    end
  end
end
