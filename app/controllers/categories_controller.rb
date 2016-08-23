class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(white_list_params)
    if @category.save
      flash[:success] = ["Congrats! #{@category.name} is created."]
      redirect_to categories_path
    else
      flash.now[:danger] = @category.errors.full_messages
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = Category.all_related_products(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(white_list_params)
      flash[:success] = ["Congrats! #{@category.name} updated!"]
      redirect_to categories_path
    else
      flash.now[:danger] = @category.errors.full_messages
      render :edit
    end
  end

  def destroy
    category = Category.find(params[:id])
    name = category.name
    if category.destroy
      flash[:success] = ["Congrats! #{name} is destroyed."]
      redirect_to categories_path
    else
      flash.now[:danger] = category.errors.full_messages
      render :edit
    end
  end

  private

  def white_list_params
    params.require(:category).permit(:name, :description)
  end


end
