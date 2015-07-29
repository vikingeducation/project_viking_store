class OrderContentsController < ApplicationController

  def update_everything
    @order = Order.find(params[:order][:id])
    OrderContent.update_all(params[:order_content])
    redirect_to order_path(@order.id)
  end

  def remove_oc
    order = Order.find(params[:order_id])
    oc = OrderContent.find(params[:id])
    if oc.destroy
      flash[:success] = "Successfully removed product from order!"
      redirect_to order_path(order.id)
    else
      flash[:danger] = "Failed to remove product from order!"
      redirect_to order_path(order.id)
    end
  end


  # Product_id must be able to be found
  # Order_id must be able to be found
  # (Validation) should fail if we have a row in order_contents where product_id and order_id are together already
  #
  def create_oc
    order = Order.find(params[:order][:id])
    errors = OrderContent.create_or_update_many(params[:order_content])
    if errors
      flash[:danger] = errors
    else
      flash[:success] = "Products properly added to order!"
    end
    redirect_to edit_order_path(order)
  end


  private


end
