class Admin::CategoriesController < AdminController
  layout 'admin'

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
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash[:success] = "You have successfully created a Category"
      redirect_to admin_categories_path
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_category_params)
      flash[:success] = "Category successfully updated"
      redirect_to admin_categories_path
    else
      flash[:error] = "Something went wrong updating your category"
      render :edit
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def destroy
     @category = Category.find(params[:id])

    if @category.destroy
      flash[:success] = "Category was successfully destroyed"
      redirect_to admin_categories_path
    else
      flash[:error] = "Could not delete Category"
      redirect_to :back
    end
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end

end
