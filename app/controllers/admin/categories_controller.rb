class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end


  def new
    @category = Category.new
  end


  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "New category created!"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Oops, something went wrong!"
      render :new
    end
  end


  private


  def category_params
    params.require(:category).permit(:name, :description)
  end
end
