class ProductsController < ApplicationController

  def index
    @products = Product.all
    render layout: "admin"
  end
  def new
    @product = Product.new
    render layout: "admin"
  end
  def show
    @product = Product.find(params[:id])
    render layout: "admin"    
  end
  def edit
    @product = Product.find(params[:id])
    render layout: "admin"    
  end
  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_params)
      redirect_to @product
    else
      render 'edit'
    end
  end
  def create
    @product = Product.new(whitelisted_params)
    @product.sku = (1000..9999).to_a.sample
    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
  end

  private
    def whitelisted_params
      params.require(:product).permit(:id, :name, :description, :price, :category_id, :sku)
    end
end

