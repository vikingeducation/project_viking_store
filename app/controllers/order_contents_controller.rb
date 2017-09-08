class OrderContentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])

    whitelisted_order_contents_params.each do |product_num, product_details|
      # skip if an invalid product_id or quantity is provided
      product_id = product_details["id"]
      quantity = product_details["quantity"]
      next if product_id.empty? || quantity.empty?

      # first check if OrderContent record already exists, if so we just
      # update the quantity of the Product in the Order
      if OrderContent.exists?(order_id: @order.id, product_id: product_id)
        @order_content = OrderContent.find_by(order_id: @order.id, product_id: product_id)

        unless @order_content.update(quantity: @order_content.quantity + quantity.to_i)
          flash[:error] = "An error occurred while attempting to update the quantity of this Product: #{Product.find(product_id).name} for this Order."
          redirect_to edit_order_path(@order) and return
        end
      # otherwise, we create a new OrderContent
      else
        @order_content = OrderContent.new(order_id: @order.id, product_id: product_id, quantity: quantity)

        if @order_content.save
          next
        else
          flash[:error] = "An error occurred while trying to add this Product: #{Product.find(product_id).name} to this Order. Please check that you've entered a valid quantity (>= 1) for this Product."
          redirect_to edit_order_path(@order) and return
        end
      end
    end

    flash[:success] = "Products successfully added to Order."
    redirect_to order_path(params[:order_id])
  end

  private

  def whitelisted_order_contents_params
    params
    .require(:order_contents)
    .permit(product_1: [:id, :quantity],
            product_2: [:id, :quantity],
            product_3: [:id, :quantity],
            product_4: [:id, :quantity],
            product_5: [:id, :quantity])
  end
end
