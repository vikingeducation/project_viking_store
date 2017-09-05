class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
    @category = Category.where(:id => @product.category_id)
    @order_contents = OrderContent.where(:product_id => params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_form_params)
      flash[:success] = "Product updated successfully."
      redirect_to product_path(@product)
    else
      flash[:error] = "Product not updated successfully."
      render :show
    end
  end

  def create
    @product = Product.new(product_form_params)
    if @product.save
      redirect_to product_path(@product)
      flash[:success] = "Product created"
    else
      flash[:error] = "Product not created"
      render :show
    end
  end

  private
  
  def product_form_params
    params.require(:product).permit(:name, :sku, :description, :price)
  end
end
