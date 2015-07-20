class ProductsController < ApplicationController

  layout 'portal'


  def index
    @products = Product.all
  end


  def show
    @product = Product.find(params[:id])
    #@products = @product.products
  end


  def new
    @product = Product.new
  end


  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = "Product successfully created!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product not saved - please try again."
      render :new
    end

  end


  def edit
    @product = Product.find(params[:id])
  end


  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      flash[:success] = "Product successfully updated!"
      redirect_to products_path
    else
      flash.now[:danger] = "Product not saved - please try again."
      render :edit
    end
  end


  def destroy
    @product = Product.find(params[:id])

    if @product.destroy
      flash[:success] = "Product deleted!"
      redirect_to products_path
    else
      flash.now[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end


  private


  def category_params
    params.require(:product).permit(:id, :name, :price, :category)
  end

end
