class DashboardController < ApplicationController

  def index
    total_revenue = OrderContent.joins(
      "JOIN orders ON orders.id = order_contents.order_id").joins(
      "JOIN products ON products.id = order_contents.product_id").where(
      "orders.checkout_date IS NOT NULL").sum(
      "products.price * order_contents.quantity")

    @total = {
      :users => User.count,
      :orders => Order.count,
      :products => Product.count,
      :revenue => total_revenue
    }
  end

end
