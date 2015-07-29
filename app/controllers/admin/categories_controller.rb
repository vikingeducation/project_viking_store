class Admin::CategoriesController < AdminController

  layout 'portal'


  def index
    @categories = Category.all
  end


  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end


  def new
    @category = Category.new
  end


  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category successfully created!"
      redirect_to categories_path
    else
      flash.now[:danger] = "Category not saved - please try again."
      render :new
    end

  end


  def edit
    @category = Category.find(params[:id])
  end


  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      flash[:success] = "Category successfully updated!"
      redirect_to categories_path
    else
      flash.now[:danger] = "Category not saved - please try again."
      render :edit
    end
  end


  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:success] = "Category deleted!"
      redirect_to categories_path
    else
      flash.now[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end


  private


  def category_params
    params.require(:category).permit(:id, :name)
  end

end
