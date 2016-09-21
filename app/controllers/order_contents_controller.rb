class OrderContentsController < ApplicationController

  def update
    @order_content = OrderContent.find(params[:id])
    @order = @order_content.order
    @user = @order.user
    params[:order].each do |oc_id, q|
      oc = OrderContent.find(oc_id)
      oc.update(quantity: q[:quantity])
    end
    redirect_to user_order_path(@user, @order)
  end

  def create
    @order = Order.find(params[:order_content][:order_id])
    @user =  @order.user
    params[:product].each do |k, v|
      next if @order.product_ids.include?(v[:productID]) || v[:productID].empty?
      order_content = OrderContent.new(order_id: @order.id,
                                       product_id: v[:productID],
                                       quantity: v[:quantity])
      order_content.save
    end
    redirect_to user_order_path(@user, @order)
  end

end
