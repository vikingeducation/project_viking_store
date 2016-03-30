class Admin::ProductsController < AdminController
  before_action :set_product, :except => [:index]

  def index
    @products = Product.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @product.update(product_params)
      flash[:success] = 'Product created'
      redirect_to admin_products_path
    else
      flash.now[:error] = 'Product not created'
      render :new
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = 'Product updated'
      redirect_to admin_products_path
    else
      flash.now[:error] = 'Product not updated'
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = 'Product deleted'
    else
      flash[:error] = 'Product not deleted, products of placed orders cannot be deleted'
    end
    redirect_to admin_products_path
  end


  private
  def set_product
    @product = Product.exists?(params[:id]) ? Product.find(params[:id]) : Product.new
  end

  def product_params
    params.require(:product).permit(
      :name,
      :sku,
      :description,
      :price,
      :category_id
    )
  end
end
