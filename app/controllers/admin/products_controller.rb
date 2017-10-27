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
    @categories = Category.all
  end


  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end


  def edit
    set_product
    @categories = Category.all
  end


  def show
    set_product
    @product_volumn = times_product_ordered
  end


  def update
    set_product
    if @product.update(whitelisted_params)
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end


  def destroy
    set_product
    @product.destroy
    redirect_to admin_products_path
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

end
