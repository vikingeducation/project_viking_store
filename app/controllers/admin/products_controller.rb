class Admin::ProductsController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @products = Product.joins('JOIN categories ON products.category_id = categories.id').
                        select("categories.name AS category_name,
                                categories.id AS category_id,
                                products.id,
                                products.name,
                                products.price")
  end

  def new
    @product = Product.new
    set_categories
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
    set_product
    set_categories
  end


  def show
    set_product
    @product_volumn = times_product_ordered
  end


  def update
    set_product
    if @product.update(whitelisted_params)
      flash[:success] = "Product Successfully Updated!"
      redirect_to admin_products_path
    else
      flash[:danger] = "Product Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    set_product
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
     Product.joins("JOIN order_contents ON products.id = order_contents.product_id").
             group("products.id").
             count
  end


  def set_categories
    @categories = Category.all
  end

end
