class OrdersController < ApplicationController

	include OrdersHelper

	def index
		if params[:user_id]
			@filtered_order = true
			if User.all.ids.include? params[:user_id].to_i
				@user = User.find(params[:user_id])
				@orders = @user.orders.limit(100).order(:id)
			else
				flash[:error] = "Bad user id! Showing all orders"
				@filtered_order = false
				@orders = Order.limit(100).order(:id)
			end
		else
			@filtered_order = false
			@orders = Order.limit(100).order(:id)
		end
	end

	def show
		@order = Order.find(params[:id])
	end

	def new
		@user = User.find(params[:user_id])
		@order = Order.new
	end

	def create
		@user = User.find(params[:user_id])
		@order = @user.orders.build(orders_params)
		if @order.save
			flash[:success] = "Order created successfully"
			redirect_to edit_user_order_path(@user.id, @order.id)
		else
			flash[:error] = "Order creation failed"
			render action: "new"
		end
	end

	def edit
		@order = Order.find(params[:id])
		@purchases = @order.order_contents.to_a
		if params[:user_id]
			@user = User.find(params[:user_id])
		else
			@user = @order.user
		end
		@in_edit_mode = true
		@cur_time = Time.now
	end

	def edit_quantity
		order = Order.find(params[:order_id])
		@order_contents = order.order_contents
		if params[:quantity]
			params[:quantity].each do |key, value|
				purchase = @order_contents.find_by(:product_id => key)
				if value == "0"
					purchase.destroy
				else
					purchase.quantity = value
					purchase.save
				end
			end
		end
		redirect_to edit_user_order_path(order.user.id, order.id)
	end

	def add_order
		order_contents_hash = Hash.new
		params[:product_id].each do |key, value|
			if order_contents_hash[value]
				order_contents_hash[value] = order_contents_hash[value] + params[:quantity][key].to_i
			else
				order_contents_hash[value] = params[:quantity][key].to_i
			end
		end
		order_contents_hash.each do |key, value|
			if Product.ids.include? key.to_i
				if value.to_i != 0
					order_content = OrderContent.new
					order_content.product_id = key
					order_content.order_id = params[:order_id]
					order_content.quantity = value
					order_content.save!
				end
			end
		end
		redirect_to edit_user_order_path(params[:user_id], params[:order_id])
	end

	def update
		order = Order.find(params[:id])
		if order.update(orders_params)
			flash[:success] = "Great! Your order has been updated!"
			redirect_to orders_path
		else
			flash[:error] = "Could not update!"
			redirect_to edit_user_order_path(order.user.id, order.id)
		end
	end

	def destroy
		@order = Order.find(params[:id])
		if @order.destroy
			flash[:success] = "Great! Your order has been removed!"
			redirect_to orders_path
		else
			flash[:error] = "Could not remove order!"
			redirect_to(:back)
		end
	end
	
end
