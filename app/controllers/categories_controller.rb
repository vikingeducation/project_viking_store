class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_params)

    if @category.save
      flash[:success] = "New category saved."
      redirect_to action: :index
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
  end

  def destroy
  end

private

  def whitelisted_params
    params.require(:category).permit(:name)
  end

end
