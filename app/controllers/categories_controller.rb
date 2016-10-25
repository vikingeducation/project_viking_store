class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @category_products = Category.find(params[:id]).products
  end

  def edit
    @category = Category.find(params[:id])
  end

	def create
		@category = Category.new(white_list_params)

		if @category.save
			redirect_to admin_path
		else
			render "new"
      flash.now[:error] = "Something went wrong"
		end
	end

  def update
    @category = Category.find(params[:id])

      if @category.update_attributes(category_params)
        flash[:notice] = "Successfully created a new category..."
        redirect_to category_path(@category)
      else
        flash[:error] = "Something went wrong"
        render "edit"
      end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

	def white_list_params
    params.require(:category).permit(:name, :description)
  end

end
