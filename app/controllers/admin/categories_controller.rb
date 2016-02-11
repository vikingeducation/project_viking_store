class Admin::CategoriesController < AdminController
  layout "admin"

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end


  def create
    @category = Category.new(whitelisted_category_params)
    if @category.save
      flash[:success] = "'#{@category.name}' successfully created"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @products = Product.where(:category_id => @category.id)
  end


  def edit
    @category = Category.find(params[:id])
  end


  def update
    @category = Category.find(params[:id])
    if @category.update(whitelisted_category_params)
      flash[:success] = "'#{@category.name}' successfully updated"
      redirect_to admin_category_path(@category)
    else
      render :edit
    end
  end


  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:success] = "'#{@category.name}' successfully deleted"
    else
      flash[:error] = "'#{@category.name}' was not deleted"
    end
    redirect_to admin_categories_path
  end




  private

  def whitelisted_category_params
    params.require(:category).permit(:name, :description)
  end


end
