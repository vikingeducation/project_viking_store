class PurchasesController < AdminController
	def update
		@purchase = Purchase.find_by(order_id: params[:id])
    if @purchase.update_attributes(whitelisted_purchase_params)
      flash[:success] = "Order updated successfully."
      redirect_to admin_user_orders_path
    else
      flash.now[:error] = "Failed to update Order."
      render 'edit'
    end
	end

	def whitelisted_purchase_params
		params.require(:purchases)
	end
end
