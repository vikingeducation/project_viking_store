class Admin::CategoriesController < ApplicationController
  layout 'portal'

  def index

    @categories = Category.all

  end

  def new

    @category = Category.new

  end

  def show

    @category = Category.find(params[:id])
    @products = Product.where("category_id = #{@category.id}").order(:id)

  end

  def create

    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category created successfully!"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = "Category failed to save - please try again."
      render :new
    end

  end

  def edit

    @category = Category.find(params[:id])

  end

  def update

    @category = Category.find(params[:id])

    if @category.update(category_params)
      flash[:success] = "Category updated successfully!"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = "Category failed to update - please try again."
      render :edit
    end

  end

  def destroy

    @category = Category.find(params[:id])

    if @category.destroy
      flash[:success] = "Category deleted successfully"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Category failed to be deleted - please try again"
      redirect_to :back
    end

  end

  private

  def category_params

    params.require(:category).permit(:id, :name)

  end

end
