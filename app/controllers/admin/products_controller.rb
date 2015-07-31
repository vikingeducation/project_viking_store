class  Admin::ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelist_product_params)
    if @product.save
      flash[:success] = "Your Product #{@product.name} has been created!"
      redirect_to [:admin, @product]
    else
      flash[:danger] = "There was an error creating your product, try again."
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelist_product_params)
      flash[:success] = "Your Product #{@product.name} has been edited!"
      redirect_to [:admin, @product]
    else
      flash[:danger] = "There was an error editing your product, try again."
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Your Product #{@product.name} has been deleted!"
      redirect_to admin_products_path
    else
      flash[:danger] = "There was an error deleting your product, try again."
      redirect_to [:admin, @product]
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  private
    def whitelist_product_params
      params.require(:product).permit(:name, :sku, :price, :description, :category_id)
    end

end
