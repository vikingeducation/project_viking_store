class ProductsController < ApplicationController
  layout 'admin'

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    @categories = Category.all
    if @product.update_attributes(product_params)
      flash[:success] = "Your Product has been edited!"
      @products = Product.all.sort
      render :index
    else
      flash[:error] = "Product edit failed! Correct your errors!"
      render :edit
    end
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @product.sku = Faker::Code.ean
    @categories = Category.all
    if @product.save
      flash[:success] = "A new Product has been created!"
      @products = Product.all.sort
      render :index
    else
      flash[:error] = "Product creation failed! Correct your errors!"
      render :new
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :category_id)
  end


  def index
    @products = Product.all.sort
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
    @ordered = OrderContent.where("product_id = ?", @product.id).joins("JOIN orders on order_contents.order_id=orders.id").where("orders.checkout_date IS NOT null").sum("order_contents.quantity")
    @carts = OrderContent.where("product_id = ?", @product.id).joins("JOIN orders on order_contents.order_id=orders.id").where("orders.checkout_date IS null").count("order_contents.quantity")
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Your Product has been deleted!"
    else
      flash[:error] = "Error! The Product lives on!"
    end
    @products = Product.all.sort
    @categories = Category.all
    render :index
  end
end
