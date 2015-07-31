class  Admin::OrderContentsController < ApplicationController

  # params[:order_content] is an array of order_contents to update
  def update_everything
    @order = Order.find(params[:order][:id])
    OrderContent.update_all(params[:order_content])
    redirect_to admin_order_path(@order.id)
  end

  def remove_oc
    order = Order.find(params[:order_id])
    oc = OrderContent.find(params[:id])
    if oc.destroy
      flash[:success] = "Successfully removed product from order!"
      redirect_to admin_order_path(order.id)
    else
      flash[:danger] = "Failed to remove product from order!"
      redirect_to admin_order_path(order.id)
    end
  end


  # order_content is an array of order_contents to create.
  # If the order_content already exists, we update it instead.
  # create_or_update_many performs a transaction so if anything fails the
  # whole transaction gets rolled back.
  def create_oc
    order = Order.find(params[:order][:id])
    errors = OrderContent.create_or_update_many(params[:order_content])
    if errors
      flash[:danger] = errors
    else
      flash[:success] = "Products properly added to order!"
    end
    redirect_to edit_admin_order_path(order)
  end


  private

end
