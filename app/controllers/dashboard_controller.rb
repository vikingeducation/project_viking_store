class DashboardController < ApplicationController
  def index
  	@users_seven_days = User.after(7.days.ago).count
  	@orders_seven_days = Order.after(7.days.ago).count
  	@products_seven_days = Product.after(7.days.ago).count
    @revenue_seven_days = Product.
      joins("JOIN order_contents ON products.id = order_contents.product_id").
      where("order_contents.created_at > ?", 7.days.ago).
      sum("order_contents.quantity * products.price")

    @users_thirty_days = User.after(30.days.ago).count
  	@orders_thirty_days = Order.after(30.days.ago).count
  	@products_thirty_days = Product.after(30.days.ago).count
  	@revenues_thirty_days = Product.
  							joins("JOIN order_contents ON products.id = order_contents.product_id").
      						where("order_contents.created_at > ?", 30.days.ago).
      						sum("order_contents.quantity * products.price")

  	@users_total = User.all.count
  	@orders_total = Order.all.count
  	@products_total = Product.all.count
  	@revenues_total = Product.
  					  joins("JOIN order_contents ON products.id = order_contents.product_id").
      				  sum("order_contents.quantity * products.price")

  end
end
