class OrderContentsController < ApplicationController
  def update
    @order_contents = OrderContents.find(params[:id])
    if @order_contents.update(whitelisted_order_contents_params)
      flash[:success] = "Order updated!"
      redirect_to order_path(@order_contents.order_id)
    else
      flash[:error] = @order_contents.errors.full_messages.to_sentence
      render "/orders/edit/"
    end
  end

  def whitelisted_order_contents_params
    params.require(:order_contents).permit(:quantity, :product_id)
  end
end
