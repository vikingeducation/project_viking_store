class ProductsController < ApplicationController

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
      redirect_to products_path
    else
      flash.now[:alert] = "Ah crap. Something went wrong."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product #{@product.name} has been updated. pew! pew! pew!"
      redirect_to products_path
    else
      flash.now[:error] = 'Aw crap. Fix that stuff below.'
      render :edit
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :description, :price, :category_id)
  end


end
