class Admin::OrderContentsController < ApplicationController
  def update
    @order = Order.find(params[:id])
    @order_contents = @order.order_contents
    fd
  end

  def destroy
    @order_content = OrderContent.find(params[:id])
    @order = @order_content.order
    @order_content.destroy
    redirect_to edit_admin_order_path(@order)
  end

  private

  def order_content_params

  end
end
