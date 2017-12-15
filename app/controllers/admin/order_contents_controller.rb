class Admin::OrderContentsController < AdminController

  def create
    @order = Order.find(params[:order_id])
    @order_content = @order.order_contents.new(new_order_contents_params)
    if @order_content.save
      flash[:notice] = "#{@order_content.quantity} #{@order_content.product.name.pluralize(@order_content.quantity)} was added to your order."
      redirect_to edit_admin_user_order_path(@order.user, @order)
    else
      render 'admin/orders/edit'
      flash.new[:error] = "Whoops."
    end
  end

  def edit
  end

  def update
    if OrderContent.update(update_order_contents_params.keys, update_order_contents_params.values)
      flash[:notice] = "Order contents updated!"
      redirect_to :back
    else
      flash.now[:failure] = "Something went wrong..."
      render :index
    end
  end

  def destroy
    order_content = OrderContent.find(params[:id])
    if order_content.destroy
      flash[:notice] = "#{order_content.product.name} was removed from this order."
      redirect_to :back
    else
      flash.now[:failure] = "Something went wrong..."
      redirect_to edit_admin_order_path(order_content.order)
    end
  end

  private

  def update_order_contents_params
    params.require(:updated_order_content)
  end

  def new_order_contents_params
    params.require(:order_content).permit(:product_id, :quantity)
  end
end
