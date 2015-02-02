class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash[:success] = "Category created successfully."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Failed to create Category."
      render 'new'
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(whitelisted_category_params)
      flash[:success] = "Category updated successfully."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Failed to update Category."
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    session[:return_to] ||= request.referer
    if @category.destroy
      flash[:success] = "Category deleted successfully."
      redirect_to admin_categories_path
    else
      flash[:error] = "Failed to delete Category."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name)
  end
end
