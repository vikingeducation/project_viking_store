class OrdersController < ApplicationController
  def destory
  end

  def index
  end

  def new
    @order = Orders.new
  end

  def create
    # @order = Order.find()
  end
end
