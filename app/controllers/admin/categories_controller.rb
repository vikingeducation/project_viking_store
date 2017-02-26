class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(whitelisted_category_params)
    if @category.save
      flash[:success] = "Category created!"
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
  end

  def show
    @category = Category.find(params[:id])
  end

  def destroy
    @category = Category.find(params[:id])
  end

  private

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end
end