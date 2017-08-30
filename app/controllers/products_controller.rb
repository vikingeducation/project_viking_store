class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order(:name)
    @product_categories = {}
    @products.each do |product|
      @product_categories[product.id.to_s] = product.category_name
    end

    render layout: "admin_portal"
  end

  def show
    @product_category_name = @product.category_name
    @in_num_orders = @product.in_num_orders
    @in_num_shopping_carts = @product.in_num_shopping_carts

    render layout: "admin_portal"
  end

  def new
    @product = Product.new

    render layout: "admin_portal"
  end

  def create
    @product = Product.new(whitelisted_product_params)

    if @product.save
      flash[:success] = "New Product successfully created."
      redirect_to products_path
    else
      flash.now[:error] = "Error creating Product."
      render layout: "admin_portal", template: "products/new"
    end
  end

  def edit
    render layout: "admin_portal"
  end

  def update
    if @product.update(whitelisted_product_params)
      flash[:success] = "Product successfully updated."
      redirect_to products_path
    else
      flash.now[:error] = "Error updating Product."
      render layout: "admin_portal", template: "products/edit"
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = "Product successfully deleted."
      redirect_to products_path
    else
      flash[:error] = "Error deleting Product."
      redirect_to :back
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def whitelisted_product_params
    params.require(:product).permit(:name, :sku, :price, :category_id)
  end
end
