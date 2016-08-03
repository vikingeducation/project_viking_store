class DashboardsController < ApplicationController
  def index
    @totals = get_totals
  end

  private

    def get_totals
      {
      users: User.total_users,
      orders: Order.total_orders,
      revenue: OrderContent.total_revenue.revenue,
      products: Product.total_products
      }

    end

end
