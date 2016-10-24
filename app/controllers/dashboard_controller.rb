class DashboardController < ApplicationController
  def index
  	@users_seven_days = User.where('created_at < ?', 7.days.ago).count
  	@orders_seven_days = Order.where('checkout_date > ?', 7.days.ago).count
    @revenue_seven_days = Product.
      joins("JOIN order_contents ON products.id = order_contents.product_id").
      where("order_contents.created_at > ?", 7.days.ago).
      sum("order_contents.quantity * products.price")

    @users_thirty_days = User.where('created_at < ?', 30.days.ago).count
  	@orders_thirty_days = Order.where('checkout_date > ?', 30.days.ago).count

  	@users_total = User.all.count
  	@orders_total = Order.all.count
  	@products_total = Product.all.count
  end
end
