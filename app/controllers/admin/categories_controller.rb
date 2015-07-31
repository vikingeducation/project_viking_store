class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.includes(:products).find(params[:id])
  end

  def create
    @category = Category.new(white_listed_cat_params)
    if @category.save
      flash[:success] = "New category created"
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Did not create category, try again."
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(white_listed_cat_params)
      flash[:success] = "Category updated."
      redirect_to admin_categories_path
    else
      flash.now[:error] = "Did not update category, try again."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category deleted."
      redirect_to admin_categories_path
    else
      flash[:error] = "Can not be deleted."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def white_listed_cat_params
    params.require(:category).permit(:name, :description)
  end
end













