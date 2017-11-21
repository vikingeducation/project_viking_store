class Admin::ProductsController < ApplicationController

  layout 'admin_portal_layout'

  before_filter :set_categories, only: [:new, :create, :edit, :update]
  before_filter :set_product, except: [:new, :create, :index]

  def index
    @products = Product.joins(:category)
  end

  def new
    @product = Product.new
  end


  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      flash[:success] = "Product Successfully Saved!"
      redirect_to admin_products_path
    else
      flash[:danger] = "Product Could Not Be Saved See Errors On Form"
      render :new
    end
  end


  def edit
  end


  def show
    @product_volumn = times_product_ordered
    @in_cart = number_in_carts
  end


  def update
    if @product.update(whitelisted_params)
      flash[:success] = "Product Successfully Updated!"
      redirect_to admin_products_path
    else
      flash[:danger] = "Product Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    if @product.destroy
      flash[:success] = "Product Successfully Deleted"
      redirect_to admin_products_path
    else
      flash[:danger] = "Could Not Delete Product"
      redirect_to admin_product_path(@product)
    end
  end



  private


  def set_product
    @product = Product.find(params[:id])
  end


  def whitelisted_params
    params.require(:product).permit(:name, :price, :category_id, :sku)
  end


  def times_product_ordered
     Order.joins(:order_contents).
           where.not(checkout_date: nil).
           group("order_contents.product_id").
           count
  end


  def number_in_carts
    Order.joins(:order_contents).
          where(checkout_date: nil).
          group("order_contents.product_id").
          count
  end


  def set_categories
    @categories = Category.all
  end

end
