class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_params)
    @product[:sku] = (Faker::Code.ean).to_i

    if @product.save
      flash[:success] = "New product saved."
      redirect_to action: :index
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])

    @product_numorders = @product.orders.count
    @product_numcarts = @product.orders.where(:checked_out => false).count
  end

  def edit
    @product = Product.find(params[:id])

  end

  def update
    @product = Product.find(params[:id])

    if @product.update(whitelisted_params)
      flash[:success] = "Updated!"
      redirect_to action: :index
    else
      flash.now[:error] = "Something went wrong."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if Product.find(params[:id]).destroy
      flash[:success] = "Deleted."
      redirect_to action: :index
    else
      flash[:error] = "Something went wrong in that deletion."
      redirect_to session.delete[:return_to]
    end
  end

private

  def whitelisted_params
    params[:product][:price] = clean_price(params[:product][:price])
    params.require(:product).permit(:name, :price, :category_id)
  end

  #takes a string parameter
  def clean_price(input)
    input[0] == "$" ? input[1..-1].to_f : input.to_f
  end

end
