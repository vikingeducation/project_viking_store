class OrderContentsController < ApplicationController
  layout 'admin'
  before_action :set_order_content,
                :set_order

  def create
    successes = []
    OrderContent.transaction do
      order_content_params_array.each do |attributes|
        @order_content = OrderContent.new(attributes)
        success = @order_content.save
        successes << success
        break unless success
      end
    end
    if successes.any? {|i| i == true}
      flash[:success] = 'OrderContents created'
    else
      flash[:error] = 'OrderContents not created'
    end
    redirect_to edit_user_order_path(@order.user, @order)
  end

  def update
    success = false
    OrderContent.transaction do
      order_content_params_array.each do |attributes|
        @order_content = OrderContent.find(attributes[:id])
        success = @order_content.update(attributes)
        break unless success
      end
    end
    if success
      flash[:success] = 'OrderContents updated'
    else
      flash[:error] = 'OrderContents not updated'
    end
    redirect_to edit_user_order_path(@order.user, @order)
  end

  def destroy
    if @order_content.destroy
      flash[:success] = 'OrderContent deleted'
    else
      flash[:error] = 'OrderContent not deleted, order_contents of placed orders cannot be deleted'
    end
    redirect_to edit_user_order_path(@order.user, @order)
  end


  private
  def set_order
    @order = Order.exists?(params[:order_id]) ? Order.find(params[:order_id]) : @order_content.order
  end

  def set_order_content
    @order_content = OrderContent.exists?(params[:id]) ? OrderContent.find(params[:id]) : OrderContent.new
  end

  def order_content_params
    params.permit(
      :order_id,
      :order_content => [
        :id,
        :quantity,
        :product_id
      ]
    )
  end

  def order_content_params_array
    order_content_params[:order_content].map do |key, value|
      {
        :id => value['id'],
        :quantity => value['quantity'],
        :product_id => value['product_id'],
        :order_id => params['order_id']
      }
    end
  end
end
