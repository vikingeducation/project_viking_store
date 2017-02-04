class OrderContentsController < ApplicationController
	
	def index
		@order_contents = Order.find(params[:order_id]).order_contents
	end

	def destroy
		@order_content = OrderContent.find(params[:id])
		if @order_content.destroy
			flash[:success] = "Great! Your order content has been removed!"
			redirect_to edit_user_order_path(params[:user_id], params[:order_id])
		else
			flash[:error] = "Could not remove order content!"
			redirect_to(:back)
		end
	end
end
