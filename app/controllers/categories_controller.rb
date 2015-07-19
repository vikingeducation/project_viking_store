class CategoriesController < ApplicationController
  layout 'portal'

  def index
    @categories = Category.all
#    render :layout => 'portal'
  end


  def show
    @category = Category.find(params[:id])
    @products = @category.products
#    render :layout => 'portal'
  end


  def new
    @category = Category.new
#    render :layout => 'portal'
  end


  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category successfully created!"
      redirect_to categories_path#, :layout => 'portal'
    else
      flash.now[:danger] = "Category not saved - please try again."
      render :new#, :layout => 'portal'
    end

  end


  private


  def category_params
    params.require(:category).permit(:id, :name)
  end

end
