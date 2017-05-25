class Admin::ProductsController < AdminController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "Product created successfully."
      redirect_to admin_products_path
    else
      flash.now[:error] = "Failed to create Product."
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update_attributes(whitelisted_product_params)
      flash[:success] = "Product updated successfully."
      redirect_to admin_products_path
    else
      flash.now[:error] = "Failed to update Product."
      render 'edit'
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if @product.destroy
      flash[:success] = "Product deleted successfully."
      redirect_to admin_products_path
    else
      flash[:error] = "Failed to delete Product."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def whitelisted_product_params
    params.require(:product).permit(:name, :sku, :price, :category_id)
  end
end
