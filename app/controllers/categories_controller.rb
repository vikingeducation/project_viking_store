class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render layout: "admin"
  end
  def new
    @category = Category.new
    render layout: "admin"
  end
  def show
    @category = Category.find(params[:id])
    render layout: "admin"    
  end
  def edit
    @category = Category.find(params[:id])
    render layout: "admin"    
  end
  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_params)
      redirect_to @category
    else
      render 'edit'
    end
  end
  def create
    @category = Category.new(whitelisted_params)
    if @category.save
      redirect_to @category
    else
      render 'new'
    end
  end
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    redirect_to categories_path
  end

  private
    def whitelisted_params
      params.require(:category).permit(:id, :name, :description)
    end
end
