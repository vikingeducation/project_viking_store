class Admin::CategoriesController < AdminController
  def index
    @categories = Category.order(:id)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash[:success] = "Category '#{@category.name}'' created!"
      redirect_to admin_categories_path
    else
      flash[:error] = "Category could not be created! #{@category.errors.full_messages[0]}."
      render action: "new"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_category_params)
      flash[:success] = "Category '#{@category.name}'' updated!"
      redirect_to admin_categories_path
    else
      flash[:error] = "Category could not be updated! #{@category.errors.full_messages[0]}."
      render action: "edit"
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "Category '#{@category.name}'' deleted!"
      redirect_to admin_categories_path
    else
      flash[:error] = "Category could not be deleted!"
      redirect_to(:back)
    end
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end
end