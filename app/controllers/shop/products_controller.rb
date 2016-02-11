class Shop::ProductsController < ShopController

  def index
    session[:product_ids] ||= []
    if params[:category_id]
      @products = Product.where(:category_id => params[:category_id]).paginate(:page => params[:page])
    else
      @products = Product.paginate(:page => params[:page])
    end
    @category_options = Category.all.map{|c| [c.name, c.id]}
  end

  def new
    session[:product_ids] << params[:product_id].to_i
    flash[:success] = "Added #{Product.find(params[:product_id]).name} to cart."
    redirect_to shop_products_path
  end

  def edit
  end

  def destroy
    session.clear
    redirect_to shop_products_path
  end

  private

  def product_params

  end


end
