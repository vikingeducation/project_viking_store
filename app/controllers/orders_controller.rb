class OrdersController < ApplicationController

  layout "member"
  #before_action :require_login

  def edit
    @order = Order.last
    session[:cart].each do |product, quantity|
      OrderContent.new(order_id: @order.id, product_id: product, quantity: quantity)
    end
  end

  def update_order
  end
end
