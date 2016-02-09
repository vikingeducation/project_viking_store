class Admin::ProductsController < AdminController

  def new
    @product = Product.new
    @categories = Category.all.name
  end


  def show
    @product = Product.find(params[:id])
    @times_ordered = Product.times_ordered(@product.id)
    @number_of_carts = Product.number_of_carts(@product.id)
  end


  def index
    @products = Product.paginate(:page => params[:page])
  end


  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "'#{@product.name}' successfully created"
      redirect_to products_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end


  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_product_params)
      flash[:success] = "'#{@product.name}' successfully updated"
      redirect_to product_path(@product)
    else
      render :edit
    end
  end


  def destroy
    @product = Product.find(params[:id])    
    if @product.destroy
      flash[:success] = "'#{@product.name}' successfully deleted"
    else
      flash[:error] = "Unable to delete '#{@product.name}'" 
    end
    redirect_to products_path
  end


 

  private

  def whitelisted_product_params
    params.require(:product).permit(:category_id, :name, :price, :sku, :description)

  end 




end
