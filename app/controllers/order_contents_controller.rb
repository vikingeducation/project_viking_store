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

  def create_oc
    @order = Order.find(params[:order][:id])
    order_contents = params[:order_content]
    order_contents.each do |oc|
      # if Product.find(oc[0]) and oc[1][:quantity].to_i > 0
      #   @order_content = OrderContent.new(product_id: oc[0].to_i,
      #                                     quantity: oc[1][:quantity].to_i,
      #                                     order_id: @order.id)
      oc.each do |c|

      end
    end
  end

end
