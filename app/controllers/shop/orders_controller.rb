class Shop::OrdersController < ShopController

  def edit
    if current_user
      @order = current_user.orders.where(:checkout_date => nil).first
    else
      @order = Cart.new
    end
    @order.product_ids << session[:product_ids]
  end



  def update
    if current_user
      @order = Order.find(params[:id])
      if @order.update(cart_params)
        flash[:success] = "Order Updated"
      else
        flash[:error] = "Order Not Updated."
      end
      redirect_to edit_shop_order_path(@order)
    end
  end

  def destroy

  end

  private

  def cart_params
    params.require(:order).permit(:order_contents_attributes => [:id, :quantity, :_destroy])
  end
end
