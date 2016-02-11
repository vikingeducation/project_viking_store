class Admin::ProductsController < AdminController
  def index
    @products = Product.all
    @product_categories = Product.find_categories
  end

  def show
    @product = Product.find(params[:id])
    @product_category = Product.find_category(@product)
    @product_orders = Product.find_orders(@product)
    @product_carts = Product.find_cart_count(@product)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      flash.notice = "You created a product"
      redirect_to admin_products_path
    else

    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_params)
      flash.notice = "You updated your product"
      redirect_to admin_products_path
    else
      flash.notice = "It didn't update"
      render :edit
    end
  end


  def destroy
    @product = Product.find(params[:id])

    @product_destroy
    flash.notice = "You destroyed the product"
    redirect_to admin_products_path
  end



  private

    def whitelisted_params
      params.require(:product).permit(:price, :name, :category_id, :sku)
    end
end
