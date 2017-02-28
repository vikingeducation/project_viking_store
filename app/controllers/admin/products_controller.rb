class Admin::ProductsController < AdminController
  def index
    @products = Product.order(:category_id, :id).includes(:category)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "Product '#{@product.name}'' created!"
      redirect_to admin_products_path
    else
      flash[:error] = "Product could not be created!"
      render action: "new"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_product_params)
      flash[:success] = "Product '#{@product.name}'' updated!"
      redirect_to admin_products_path
    else
      flash[:error] = "Product could not be updated!"
      render action: "edit"
    end
  end

  def show
    @product = Product.find(params[:id])
    @order_count = @product.get_order_count
    @cart_count = @product.get_cart_count
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product '#{@product.name}' deleted!"
      redirect_to admin_products_path
    else
      flash[:error] = "Product could not be deleted!"
      redirect_to(:back)
    end
  end

  private

  def whitelisted_product_params
    params.require(:product).permit(:name, :description, :sku, :price, :category_id)
  end
end