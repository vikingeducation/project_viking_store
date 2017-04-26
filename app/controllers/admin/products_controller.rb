class Admin::ProductsController < ApplicationController
  layout 'admin_portal_layout'

  def index
    @products = Product.all
    # render "/admin/products/index", :locals => {:products => @products }
  end

  def show
    @product = Product.find(params[:id])
    @product_times_ordered = Product.times_ordered(params[:id])
    @product_times_in_carts = Product.times_in_carts(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_product_params)
    price_dol = @product.price.to_s
    @product.price = price_dol.match(/\d*\.\d*/)[0].to_s
    if @product.save
      flash[:success] = "New Product has been added"
      redirect_to admin_products_path
    else
      flash.now[:danger] = "The products could not be added. Try again."
      render 'new', :locals => {:product => @product}
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    price_dol = @product.price.to_s
    @product.price = price_dol.match(/\d*\.\d*/)[0].to_s
    if @product.update_attributes(whitelisted_product_params)
      flash[:success] = "The product has been successfully updated"
      redirect_to admin_products_path
    else
      flash.now[:danger] = "The product cannot be updated."
      render 'edit', :locals => {:product => @product}
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product deleted successfully!"
      redirect_to admin_products_path
    else
      flash[:danger] = "Failed to delete product"
      redirect_to request.referer
    end
  end



  private
  def whitelisted_product_params
    params.require(:product).permit(:name, :price, :sku, :category_id )
  end


end
