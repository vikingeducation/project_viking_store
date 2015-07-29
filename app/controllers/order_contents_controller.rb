class OrderContentsController < ApplicationController
  def update_everything
    @order = Order.find(params[:order][:id])
    order_contents = params[:order_content]
    order_contents.each do |oc|
      if OrderContent.find(oc[0]) && oc[1][:quantity].to_i <= 0
        OrderContent.find(oc[0]).destroy
      else
        OrderContent.find(oc[0]).update(quantity: oc[1][:quantity])
      end
    end
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
    oc = params[:order_content]
    oc.reject! { |p_oc| p_oc[:product_id] == "" || p_oc[:quantity] == "" || p_oc[:quantity].to_i <= 0}
    oc.each do |potential_oc|
      if OrderContent.find_by(order_id: potential_oc[:order_id])
        unless OrderContent.create(order_id: potential_oc[:order_id], product_id: potential_oc[:product_id], quantity: potential_oc[:quantity])
          flash[:danger] = "Failed to create row in order_contents table."
          redirect_to edit_order_path(order)
          break
        end
      else
        flash[:danger] = "Could not find order or product id."
        redirect_to edit_order_path(order)
        break
      end
    end
    flash[:success] = "Products properly added to order!"
    redirect_to order
  end

  private

  def whitelist_order_contents
    params.permit(:order_content => [])
  end
end
