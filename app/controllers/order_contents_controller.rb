class OrderContentsController < ApplicationController
  layout 'admin'
  before_action :set_order_content

  def destroy
    if @order_content.destroy
      flash[:success] = 'OrderContent deleted'
    else
      flash[:error] = 'OrderContent not deleted, order_contents of placed orders cannot be deleted'
    end
    redirect_to edit_user_order_path(@order_content.order.user, @order_content.order)
  end


  private
  def set_order_content
    @order_content = OrderContent.exists?(params[:id]) ? OrderContent.find(params[:id]) : OrderContent.new
  end

  def order_content_params
    params.require(:order_content).permit(
      :quantity,
      :order_id,
      :product_id
    )
  end
end
