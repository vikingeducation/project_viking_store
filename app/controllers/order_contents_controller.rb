class OrderContentsController < ApplicationController
  def destroy
    @order_content = OrderContent.find(params[:id])
    if @order_content.destroy
      flash[:success] = "You've deleted an item in the order contents!"
      redirect_to edit_order_path(params[:order_id])
    else
      flash[:error] = "Error! Couldn't delete the item in the order contents!"
      redirect_to :back
    end
  end
end
