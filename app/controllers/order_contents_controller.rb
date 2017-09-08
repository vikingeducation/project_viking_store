class OrderContentsController < ApplicationController
  # TODO: refactor this into a non-RESTful action
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

  def update_order
    if OrderContent.update(update_order_contents_params.keys, update_order_contents_params.values)


      update_order_contents_params.each do |order_content_id, order_details|
        if order_details[:quantity].to_i == 0
          unless OrderContent.destroy(order_content_id)
            flash[:error] = "An error occurred when removing a Product with 0 quantity from this Order."
            redirect_to edit_order_path(params[:order_id])
          end
        end
      end

      flash[:success] = "Order successfully updated with new Product quantities."
      redirect_to order_path(params[:order_id])
    else
      flash.now[:error] = "Error updating Order with new Product quantities."
      render "orders/edit", template: "admin_layout"
    end

    # flash[:success] = update_order_contents_params
    # redirect_to edit_order_path(params[:order_id])
  end

  def destroy
    @order_content = OrderContent.find(params[:id])

    if @order_content.destroy
      flash.now[:success] = "Product successfully removed from Order."
      redirect_to edit_order_path(@order_content.order_id)
    else
      flash.now[:error] = "An error occurred while removing Product from Order."
      render "orders/edit", template: "admin_layout"
    end
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

  def update_order_contents_params
    params.require(:order_contents)
  end
end
