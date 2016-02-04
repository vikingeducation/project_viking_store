class ProductsController < ApplicationController

  def index
    @products = Product.all.order("sku")
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
    @cate = choices
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def new
    @product = Product.new
    @cate = choices
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end


private
  def product_params
    params.require(:product).permit(
      :name,
      :sku,
      :description,
      :price,
      :category_id,
      :created_at,
      :updated_at,
      )
  end

  def choices
    sample = []
    num = 1
    Category.all.each do |cate|
      sample << ["#{cate.name} ( #{cate.id})", cate.id]
      num += 1
    end
    return sample
  end


end
