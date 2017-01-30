class ProductsController < ApplicationController
	def index
		@products = Product.joins("JOIN categories ON products.category_id = categories.id").select("products.*, categories.name AS cname").order(:id).to_a
	end

	def new
		@product = Product.new
	end

	def show
		@product = Product.joins("JOIN categories ON products.category_id = categories.id").select("products.*, categories.name AS cname").find(params[:id])
		@num_ordered = OrderContent.joins("JOIN orders ON orders.id = order_contents.order_id")
					.where.not("orders.checkout_date" => nil)
					.where(:product_id => @product.id)
					.sum(:quantity)
		@num_in_cart = OrderContent.joins("JOIN orders ON orders.id = order_contents.order_id")
					.where("orders.checkout_date" => nil)
					.where(:product_id => @product.id)
					.sum(:quantity)
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

	def products_params
    	params.require(:product).permit(:name, :description, :price, :category_id)
  	end
end
