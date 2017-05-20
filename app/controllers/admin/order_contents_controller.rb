class Admin::OrderContentsController < ApplicationController

  def destroy
    @order_content = OrderContent.find(params[:id])
    @order_content.destroy
    flash[:success] = "Order Content removed successfully"
    redirect_back :fallback_location => edit_admin_order_path(@order_content.order.id)
  end

end
