class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelist_category_params)
    if @category.save
      flash[:success] = 'Category #{@category.name} successfully created!'
      redirect @category
    else
      flash[:error] = 'Oops, there was an error creating your category'
       render :new
     end

  end

  private
    def whitelist_category_params
      params.require(:category).permit(:name, :description)
    end
end
