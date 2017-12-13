class Admin::CategoriesController < AdminController

  before_action :set_category, only: [:edit, :show, :update, :destroy]


  def index
    @categories = Category.all.order('name')
  end

  def new
    session[:return_to] ||= request.referer
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category #{@category.name} has been created. Beeeewm."
      # redirect_to categories_path
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "Ah crap. Something went wrong."
      render :new
    end
  end

  def show
    @products = @category.products
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "#{@category.name} has been updated."
      redirect_to admin_category_path(@category)
    else
      flash.now[:error] = "Whoopsie doopers"
      render :edit
    end
  end

  def destroy
    @category.destroy
    flash[:alert] = "#{@category.name} has been deleted along with any related products. Never to return again. I hope you're happy."
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

end
