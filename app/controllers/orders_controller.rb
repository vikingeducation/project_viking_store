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
		@purchases = @order.order_contents
		puts "order products is #{@order.products.count}"
		if params[:user_id]
			@user = User.find(params[:user_id])
		else
			@user = @order.user
		end
		@in_edit_mode = true
		@cur_time = Time.now
	end

	def update

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
