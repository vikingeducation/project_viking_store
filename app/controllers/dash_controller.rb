class DashController < ApplicationController
  def index
    @users = User.all
    @orders = Order.all
    @products = Product.all
    @contents = OrderContent.all
    @addresses = Address.all
    @states = State.all
    #Highest Single Order Value
    @single = User.joins("JOIN orders on users.id = orders.user_id").joins("JOIN order_contents on orders.id = order_contents.order_id").joins("JOIN products on products.id = order_contents.product_id").select("users.first_name, users.last_name, orders.id, sum(ROUND(products.price*order_contents.quantity,2))").group("users.first_name, users.last_name, orders.id").order("sum DESC").first
    #H lifetime value
    @lifetime = User.joins("JOIN orders on users.id = orders.user_id").joins("JOIN order_contents on orders.id = order_contents.order_id").joins("JOIN products on products.id = order_contents.product_id").select("users.first_name, users.last_name, sum(ROUND(products.price*order_contents.quantity,2))").group("users.first_name, users.last_name").order("sum DESC").first
    #Hi orders placed
    @mostorders = User.joins("JOIN orders on users.id = orders.user_id").select("users.first_name, users.last_name, count(orders.id)").group("users.first_name, users.last_name").order("count(orders.id) DESC").first
  end
end
