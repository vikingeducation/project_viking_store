class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :create, :update]

  def index
    @products = Product.all
  end

  def show
    @category = @product.category
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    # TODO: add sku to form or generate it better
    @product.sku = Faker::Code.ean

    if @product.save
      redirect_to admin_products_url, notice: 'Product successfully created!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_url, notice: 'Product successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to admin_products_url, notice: 'Product successfully deleted.'
    else
      redirect_to :back, alert: 'Unable to delete product.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @categories = Category.order(:name)
  end

  def product_params
    params.require(:product).permit(:name, :price, :category_id)
  end
end
