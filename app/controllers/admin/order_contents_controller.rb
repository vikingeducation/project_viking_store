class Admin::OrderContentsController < AdminController

  def create
    @order = Order.find(params[:order_id])
    @existing_contents = @order.contents

    if @existing_contents.find_by(product_id: new_order_contents_params[:product_id])
      existing_product = @existing_contents.find_by(product_id: new_order_contents_params[:product_id])
      existing_product.quantity += new_order_contents_params[:quantity].to_i
      existing_product.save
      flash[:notice] = "Order Updated"
      redirect_to edit_admin_user_order_path(@order.user, @order)
    else
      @order_content = @order.order_contents.new(new_order_contents_params)
      if @order_content.save
        flash[:notice] = "Your order was updated with #{@order_content.quantity} #{@order_content.product.name.pluralize(@order_content.quantity)}."
        redirect_to edit_admin_user_order_path(@order.user, @order)
      else
        render 'admin/orders/edit'
        flash.new[:error] = "Whoops."
      end
    end
  end

  def edit
  end

  def update
    if OrderContent.update(update_order_contents_params.keys, update_order_contents_params.values)
      updated_contents = OrderContent.where('id IN (?)', update_order_contents_params.keys)
      if items_with_zero = updated_contents.where(quantity: 0)
        items_with_zero.each do |item|
          item.destroy
        end
      end
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
