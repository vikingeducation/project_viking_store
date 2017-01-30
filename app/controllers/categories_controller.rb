class CategoriesController < ApplicationController
	def index
		@categories = Category.order(:id)
	end

	def new
		@category = Category.new
	end

	def show
		@category = Category.find(params[:id])
		@products = Product.where(:category_id => params[:id]).order(:id).to_a
	end

	def create
		@category = Category.new(categories_params)
		if @category.save
			flash[:success] = "Category created successfully"
			redirect_to categories_path
		else
			flash[:error] = "Category creation failed"
			render action: "new"
		end
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update(categories_params)
			flash[:success] = "Great! Your category has been updated!"
			redirect_to categories_path
		else
			flash[:error] = "Could not update!"
			render action: "edit"
		end
	end

	def destroy
		@category = Category.find(params[:id])
		if @category.destroy
			child_products = Product.where(:category_id => params[:id]).to_a
			child_products.each do |product|
				product.category_id = nil
			end
			flash[:success] = "Great! Your category has been removed!"
			redirect_to categories_path
		else
			flash[:error] = "Could not remove category!"
			redirect_to(:back)
		end
  	end

	def categories_params
    	params.require(:category).permit(:name, :description)
  	end
end
