class ProductsController < ApplicationController

	include ProductsHelper

	def index
		@products = Product.order(:id)
	end

	def new
		@product = Product.new
	end

	def show
		@product = Product.find(params[:id])
		@num_ordered = @product.placed_times
		@num_in_cart = @product.in_carts
	end

	def create
		if params[:product][:price].include? "$"
			params[:product][:price] = params[:product][:price].tr('$','')
		end
		@product = Product.new(products_params)
		@product.sku = Faker::Number.number(13)
		if @product.save
			flash[:success] = "Product created successfully"
			redirect_to products_path
		else
			flash[:error] = "Product creation failed"
			render action: "new"
		end
	end

	def edit
		@product = Product.find(params[:id])
	end

	def update
		if params[:product][:price].include? "$"
			params[:product][:price] = params[:product][:price].tr('$','')
		end
		@product = Product.find(params[:id])
		if @product
			if @product.update(products_params)
				flash[:success] = "Great! Your product has been updated!"
				redirect_to products_path
			else
				flash[:error] = "Could not update!"
				render action: "edit"
			end
		end
	end

	def destroy
		@product = Product.find(params[:id])
		if @product.destroy
			flash[:success] = "Great! Your product has been removed!"
			redirect_to products_path
		else
			flash[:error] = "Could not remove product!"
			redirect_to(:back)
		end
  	end
end
