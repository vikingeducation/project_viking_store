class Admin::OrderContentsController < AdminController
  before_action :set_order_content,
                :set_order

  def create
    if @order.create_items(order_content_params)
      flash[:success] = 'OrderContents created'
    else
      flash[:error] = [
        'OrderContents not created',
        @order.errors.full_messages.join(', ')
      ].join(': ')
    end
    redirect_to edit_admin_user_order_path(@order.user, @order)
  end

  def update
    if @order.update_items(order_content_params)
      flash[:success] = 'OrderContents updated'
    else
      flash[:error] = [
        'OrderContents not created',
        @order.errors.full_messages.join(', ')
      ].join(': ')
    end
    redirect_to edit_admin_user_order_path(@order.user, @order)
  end

  def destroy
    if @order_content.destroy
      flash[:success] = 'OrderContent deleted'
    else
      flash[:error] = 'OrderContent not deleted, order_contents of placed orders cannot be deleted'
    end
    redirect_to edit_admin_user_order_path(@order.user, @order)
  end


  private
  def set_order
    @order = Order.exists?(params[:order_id]) ? Order.find(params[:order_id]) : @order_content.order
  end

  def set_order_content
    @order_content = OrderContent.exists?(params[:id]) ? OrderContent.find(params[:id]) : OrderContent.new
  end

  def order_content_params
    OrderContent.params_to_attributes(params.permit(
      :order_id,
      :order_content => [
        :id,
        :quantity,
        :product_id
      ]
    ))
  end
end
