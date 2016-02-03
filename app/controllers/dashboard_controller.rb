class DashboardController < ApplicationController

  def index
    @addresses = Address.all
    @categories = Category.all
    @cities = City.all
    @credit_cards = CreditCard.all
    @orders = Order.all
    @order_contents = OrderContent.all
    @products = Product.all
    @states = State.all
    @users = User.all
  end
end
