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
    @product = Product.new(whitelisted_category_params)
    if @product.save
      flash[:success] = "New Product has been added"
      redirect_to admin_products_path
    else
      flash.now[:danger] = "The products could not be added. Try again."
      render 'new', :locals => {:product => @product}
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end



  private
  def whitelisted_category_params
    params.require(:product).permit(:name, :price, :sku, :category_id)
  end


end
