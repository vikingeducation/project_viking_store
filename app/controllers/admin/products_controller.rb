class Admin::ProductsController < AdminController

  before_action :set_product, only: [:show, :edit, :update, :destroy]


  def index
    @products = Product.all.order('name')
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "Product #{@product.name} has been created. Beeeewm."
      redirect_to admin_products_path
    else
      flash.now[:alert] = "Ah crap. Something went wrong."
      render :new
    end
  end

  def show
  end

  def edit
    session[:return_to] ||= request.referer
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product #{@product.name} has been updated. pew! pew! pew!"
      redirect_to session.delete(:return_to)
    else
      flash.now[:error] = 'Aw crap. Fix that stuff below.'
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:alert] = "#{@product.name} has been deleted. I hope you're happy, 'cause, there's no undo."
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :description, :price, :category_id)
  end


end
