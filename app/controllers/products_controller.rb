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
   @product = Product.new(product_params)
   if @product.save
     flash[:success] = "Product Created!"
     redirect_to @product
   else
     render 'new'
   end
 end

 def edit
   @product = Product.find(params[:id])
 end

 def update
   @product = Product.find(params[:id])
   if @product.update_attributes(product_params)
     flash[:success] = "Update successful!"
     redirect_to @products
   else
     flash[:warning] = "Product did not update, please try again."
     render 'edit'
   end
 end

 def destroy
  @product = Product.find(params[:id])
  if @product.delete
   flash[:success] = "Product deleted!"
   redirect_to @products
  else
    flash[:warning] = "Product was not deleted, please try again."
    render 'index'
  end
 end
end
