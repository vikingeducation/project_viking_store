class CategoriesController < ApplicationController
  layout 'admin'

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "A new Category has been created!"
      @categories = Category.all
      render :index
    else
      flash[:error] = "Category creation failed! Correct your errors!"
      render :new
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      flash[:success] = "Your Category has been edited!"
      @categories = Category.all
      render :index
    else
      flash[:error] = "Category edit failed! Correct your errors!"
      render :edit
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = Product.where("category_id = ?", @category.id)
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Your Category has been deleted!"
    else
      flash[:error] = "Error! The Category lives on!"
    end
    @categories = Category.all
    render :index
  end
end
