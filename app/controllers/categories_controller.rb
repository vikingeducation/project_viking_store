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
  end

  def edit
  end

  private

  def white_list_params
    params.require(:category).permit(:name, :description)
  end


end
