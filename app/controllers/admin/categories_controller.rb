class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all.order("name ASC")
  end


  def show
    @category = Category.find(params[:id])
    @products = Product.where("category_id = #{@category.id}").order("name ASC")
  end


  def new
    @category = Category.new
  end


  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "New Category created!"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = "Oops, something went wrong."
      render :new
    end
  end


  def edit
    @category = Category.find(params[:id])
  end


  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:info] = "Category Updated."
      redirect_to admin_categories_path
    else
      flash.now[:danger] = "Oops, something went wrong."
      render :edit
    end
  end


  def destroy
    begin
      category = Category.find(params[:id])
      products = Product.where("category_id = #{category.id}")
      if category.destroy
        products.update_all(category_id: nil)
        flash[:warning] = "Category deleted."
        redirect_to admin_categories_path
      else
        flash[:danger] = "Oops, something went wrong."
        redirect_to :back
      end
    rescue
      flash[:danger] = "Oops, something went wrong."
      redirect_to :back
    end
  end


  private


  def category_params
    params.require(:category).permit(:name, :description)
  end
end
