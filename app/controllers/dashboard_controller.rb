class DashboardController < ApplicationController
  def index
  	@user_seven = User.new_users(7)
  	@user_thirty = User.new_users(30)
  	@user_total = User.all.count
  	@order_seven = Order.new_orders(7)
  	@order_thirty = Order.new_orders(30)
  	@order_total = Order.all.count
  	@product_seven = Product.new_products(7)
  	@product_thirty = Product.new_products(30)
  	@product_total = Product.all.count
    @revenue_seven =revenue(7)
    @revenue_thirty = revenue(30)
    @revenue_total = revenue

  end

  def show
  end


  private

  def revenue(input = nil)
    # if input is given:
    table = Order.where("checkout_date > ?", input.days.ago).joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id") if input

    # if no input, get all orders with checkout date
    table = Order.where("checkout_date IS NOT NULL").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id") unless input

    table = table.select(:order_id, :quantity, :product_id, :price)

    revenue = table.select("round(SUM(quantity * price), 2) AS sum")

    revenue.first[:sum]


  end
end
