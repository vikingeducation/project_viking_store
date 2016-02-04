class CategoriesController < ApplicationController
  def index
    @cates = Category.all.order("name") #get all categories
  end

  def show
    @cate = Category.find(params[:id])
  end

  def edit
    @cate = Category.find(params[:id])
  end

  def update
    @cate = Category.find(params[:id])
    if @cate.update_attributes(category_params)
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def new
    @cate = Category.new
  end

  def create
    @cate = Category.new(category_params)
    if @cate.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def destroy
    @cate = Category.find(params[:id])
    @cate.destroy
    redirect_to categories_path
  end


private
  def category_params
    params.require(:category).permit(:name, :description, :created_at, :updated_at)
  end

end
