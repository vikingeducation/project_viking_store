class Admin::OrderContentsController < AdminController
  before_action :set_order_content,
                :set_order

  def create
    # put this in your model
    successes = []
    OrderContent.transaction do
      order_content_params_array.each do |attributes|
        @order_content = OrderContent.new(attributes)
        success = @order_content.save
        successes << success
        break unless success
      end
    end

    # if batch creation successful
    if successes.any? {|i| i == true}
      flash[:success] = 'OrderContents created'
    else
      flash[:error] = [
        'OrderContents not created',
        @order_content.errors.full_messages.join(', ')
      ].join(': ')
    end
    redirect_to edit_admin_user_order_path(@order.user, @order)
  end

  def update
    # put in model
    success = false
    OrderContent.transaction do
      order_content_params_array.each do |attributes|
        @order_content = OrderContent.find(attributes[:id])
        success = attributes[:quantity].to_i > 0 ? @order_content.update(attributes) : @order_content.destroy
        break unless success
      end
    end

    # if batch update successful
    if success
      flash[:success] = 'OrderContents updated'
    else
      flash[:error] = [
        'OrderContents not created',
        @order_content.errors.full_messages.join(', ')
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
    # put in model
    products = {}
    order_content_params[:order_content].each do |key, value|
      if products[value['product_id']]
        products[value['product_id']][:quantity] += value['quantity'].to_i
      else
        products[value['product_id']] = {
          :id => value['id'],
          :quantity => value['quantity'].to_i,
          :product_id => value['product_id'],
          :order_id => params['order_id']
        }
      end
    end
    products.map {|key, value| value}
  end
end
