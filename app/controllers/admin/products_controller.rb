class Admin::ProductsController < AdminController

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: "Product Created!"
    else
      flash.now[:alert] = "Failed to create product."
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product Updated!"
    else
      flash.now[:alert] = "Failed to update product."
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to admin_products_path, notice: "Product Destroyed!"
    else
      redirect_to :back, alert: "Failed to Delete Product."
    end
  end

  private

  def product_params
    params.require(:product).permit(:name,:price,:category_id,:sku,:description)
  end
end
