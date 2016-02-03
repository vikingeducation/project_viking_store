class DashboardsController < ApplicationController
  def index
    @weekly = {ord_total: Order.total(7), prod_total: Product.total(7), user_total: User.total(7), rev_total: OrderContent.revenue(7)}
    @monthly = {ord_total: Order.total(30), prod_total: Product.total(30), user_total: User.total(30), rev_total: OrderContent.revenue(30)}
    @total = {ord_total: Order.total, prod_total: Product.total, user_total: User.total, rev_total: OrderContent.revenue}

    @states_list = User.top_states
    @cities_list = User.top_cities

    @biggest_order = {big_ord: OrderContent.biggest_order, big_life: OrderContent.biggest_lifetime, big_avg: OrderContent.average_order, most_ord: OrderContent.most_orders}

    @weekly_stats = {ord_total: Order.total(7), rev_total: OrderContent.revenue(7), ord_avg: OrderContent.average_orders(7), big_ord: OrderContent.biggest_order(7)}
    @monthly_stats = {ord_total: Order.total(30), rev_total: OrderContent.revenue(30), ord_avg: OrderContent.average_orders(30), big_ord: OrderContent.biggest_order(30)}
    @total_stats = {ord_total: Order.total, rev_total: OrderContent.revenue, ord_avg: OrderContent.average_orders, big_ord: OrderContent.biggest_order}

    @days = []
    7.times do |idx|
      @days << Order.order_by_day(idx)
    end

    @weeks = []
    7.times do |idx|
      @weeks << Order.order_by_week(idx)
    end
  end

end
