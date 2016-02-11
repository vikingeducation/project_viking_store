class DashboardController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def orders_by_week
    @orders_by_week = Order.orders_by_week.limit(7).to_a.map do |data|
      hash = {
        week: data.week.strftime("%m/%d"),
        sum: data.sum,
        label: number_to_currency(data.sum),
        quantity: data.quantity
      }
      hash
    end
    render json: @orders_by_week
  end

  def orders_by_day
    @orders_by_day = Order.orders_by_day.limit(7).to_a.map do |data|
      hash = {
        day: data.day.strftime("%m/%d"),
        sum: data.sum,
        quantity: data.quantity
      }
      hash
    end
    render json: @orders_by_day
  end

  def index
    @highest_order_value = User.highest_order_value.first
    @highest_lifetime_order_value = User.highest_lifetime_order_value.first
    @highest_average_order_value = User.highest_average_order_value.first

    @orders_by_day = Order.orders_by_day.limit(7)
    @orders_by_week = Order.orders_by_week.limit(7)
  end
end
