class ProductsController < ApplicationController

  # CONSTANT VARS
  MIN_PRICE  = 0.01
  MAX_PRICE = 10000.00

  def index
    @products = Product.all
    render :layout => "admin_interface"
  end

  def edit
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
    @times_ordered = @product.times_ordered
    @carts_in = @product.carts_in
  end

  def create
    params[:product][:price] = strip_currency_symbol((params[:product][:price]).to_s)
    if valid_price?
      @product = Product.new(product_params)
      if @product.save
        flash[:success] = "New Product \"#{@product.title}\" has been successfully created!"
        redirect_to products_path
        return
      else
        flash[:error] = "Product \"#{@product.title}\" was not created, please try again"
      end
    end # valid price
    render 'new'
  end

def update
    @product = Product.find(params[:id])
    if anything_to_update?
      if valid_price?
        if @product.update(product_params)
          flash[:success] = "Product \"#{@product.title}\" has been successfully updated"
          redirect_to products_path
          return
        else
          flash[:error] = "Product \"#{@product.title}\" did not update, please try again"
        end
      end # valid_price
    end # anything_to_update?
    render 'edit' # something wasn't right, give them another chance
end

def destroy
   session[:return_to] ||= request.referer
    @product = Product.find(params[:id])
    if Product.find(params[:id]).destroy
      flash[:success] = "Product \"#{@product.title}\" has been successfully deleted."
      redirect_to products_path
    else
      flash[:error] = "Product \"#{@product.title}\" did not deleted, please try again"
      redirect_to session.delete(:return_to)
    end
end

# ---- utility methods ----

  private

  def product_params
    params.require(:product).permit(:title, :price, :sku, :description, :category_id)
  end

##
# Returns True if new price is between min & max price constraints
def valid_price?
  price = params[:product][:price].to_f # just to shorten this var
  if (price >= MIN_PRICE) && (price < MAX_PRICE)
    return true
  else
    flash[:error] = "Please enter a Price between #{MIN_PRICE} and #{MAX_PRICE}."
    return false
  end
end

##
# Strip out anything besides numbers and one decimal point
  def strip_currency_symbol(price)
      price.gsub(/[^\d*\.\d*]/,"").to_f.round(2)
  end

##
# Check if any field has actually been updated or not
  def anything_to_update?
    # TODO check incoming params against object for differences
    # if nothing has changed return false to save us the work
    return true    # stubbed in for now
  end
end
