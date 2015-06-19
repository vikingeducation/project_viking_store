class Admin::ProductsController < AdminController
  layout "admin"

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "Product created!"
      redirect_to admin_products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/admin/products/new"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product obliterated!"
      redirect_to admin_products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/admin/products"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
    @times_product_ordered = @product.orders.where("checkout_date IS NOT NULL").count
    @product_in_carts = @product.orders.where("checkout_date IS NULL").count
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_product_params)
      flash[:success] = "Category updated!"
      redirect_to admin_products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/admin/products/edit"
    end
  end

  def whitelisted_product_params
    params.require(:product).permit(:name, :sku, :description, :price, :category_id)
  end
end
