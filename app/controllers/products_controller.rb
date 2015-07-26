class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:id)
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new
    @product.name = params[:product][:name]
    @product.sku = params[:product][:sku].to_f
    @product.description = params[:product][:description]
    @product.price = params[:product][:price].to_s.gsub(/[^\d\.-]/,'').to_f.abs
    @product.category_id = params[:product][:category_id].to_i

    if @product.save
      flash[:success] = "Product #{@product.name} successfully created!"
      redirect_to @product
    else
      flash.now[:danger] = 'Oops, there was an error creating your product.'
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.name = params[:product][:name]
    @product.sku = params[:product][:sku].to_f
    @product.description = params[:product][:description]
    @product.price = params[:product][:price].to_s.gsub(/[^\d\.-]/,'').to_f.abs
    @product.category_id = params[:product][:category_id]

    if @product.save
      flash[:success] = "Product #{@product.name} successfully updated!"
      redirect_to @product
    else
      flash.now[:danger] = 'Oops, there was an error updating your product.'
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product #{@product.name} successfully deleted!"
      redirect_to products_path
    else
      flash.now[:danger] = 'Oops, there was an error deleting your product.'
      render @product
    end
  end

end
