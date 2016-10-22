class Admin::ProductsController < AdminController
  layout 'admin'

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @categories = Category.all.name
  end

  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "You have successfully created a Product"
      redirect_to admin_products_path
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_product_params)
      flash[:success] = "Product successfully updated"
      redirect_to admin_products_path
    else
      flash[:error] = "Something went wrong updating your product"
      render :edit
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def destroy
     @product = Product.find(params[:id])

    if @product.destroy
      flash[:success] = "Product was successfully destroyed"
      redirect_to admin_products_path
    else
      flash[:error] = "Could not delete Product"
      redirect_to :back
    end
  end

  private

  def whitelisted_product_params
    params.require(:product).permit(:name, :price, :category, :description, :sku, :category_id)
  end
end
