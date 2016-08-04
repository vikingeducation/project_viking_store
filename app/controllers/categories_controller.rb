class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    render :index, layout: "admin_layout"
  end

  def new
    @category = Category.new
    render :new, layout: "admin_layout"
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "You're category has been saved"
      redirect_to categories_path
    else
      flash.now[:alert] = @category.errors.full_messages
      render :new, layout: "admin_layout"
    end
  end

  def edit
    @category = Category.find(params[:id])
    render :edit, layout: "admin_layout"
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "You're category has been updated"
      redirect_to categories_path
    else
      flash.now[:alert] = @category.errors.full_messages
      render :edit, layout: "admin_layout"
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :description)
    end

end
