class CategoriesController < ApplicationController

	include CategoriesHelper

	def index
		@categories = Category.order(:id)
	end

	def new
		@category = Category.new
	end

	def show
		@category = Category.find(params[:id])
		@products = @category.products
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
			flash[:success] = "Great! Your category has been removed!"
			redirect_to categories_path
		else
			flash[:error] = "Could not remove category!"
			redirect_to(:back)
		end
  	end

end
