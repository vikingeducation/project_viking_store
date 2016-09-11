class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:id)
    @products_categories = {}
    @products.each { |p| @products_categories[p.id] = Product.category(p.id) }
  end

  def show
    @product = Product.find(params[:id])
    @num_orders = Product.num_orders(params[:id])
    @num_carts = Product.num_carts(params[:id])
  end
  def new
    @product = Product.new
    @categories = []
    Category.all.each { |category| @categories << [category[:name], category[:id]]}
  end

  def create
    new_product = Product.new(whitelist_params)
    if new_product.save
      flash[:success] = "yeah, new product created!"
      redirect_to products_path
    else
      @product = new_product
      show_errors(@product.errors.messages)
      @categories = []
      Category.all.each { |category| @categories << [category[:name], category[:id]]}
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelist_params)
      flash[:success] = "yeah, product updated!"
      redirect_to products_path
    else
      show_errors(@product.errors.messages)
      @categories = []
      Category.all.each { |category| @categories << [category[:name], category[:id]]}
      render :edit
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = []
    Category.all.each { |category| @categories << [category[:name], category[:id]]}
  end

  def destroy
    product = Product.find(params[:id])
    if product
      product.destroy
      flash[:success] = "product #{product.name} deleted!"
      redirect_to products_path
    else
      render :index
    end
  end

  private
    def whitelist_params
      params.require(:product).permit(:name, :sku, :description, :price, :category_id)
    end

    def show_errors(messages)
      flash.now[:danger] = []
      messages.each do |type, errors|
        errors.each do |err|
          flash.now[:danger] << type.to_s.titleize + " " + err
        end
      end
    end
end
