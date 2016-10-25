class ProductsController < ApplicationController
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
    @product = Product.new

    if @product.save
      redirect_to @product
    else
      render "new"
    end
  end

  def edit
	  @product = Product.find(params[:id])
  end

  def update
  	@product = Product.find(params[:id])

  	if @product.update_attributes(white_list_params)
  	  flash[:success] = "Product updated...."
      redirect_to @product
  	else
      flash[:error] = "Something went wrong"
      render "edit"
  	end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_path
  end

  private

  def white_list_params
  	params.require(:product).permit(:name, :description)
  end
end
