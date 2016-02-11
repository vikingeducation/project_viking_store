class ProductsController < AdminController

  layout "application"

  def index
    filter = params[:category_filter]
    if filter
      @products = Product.where("category_id=#{filter}").paginate(page: params[:page], per_page: 9)
    else
      @products = Product.paginate(page: params[:page], per_page: 9)
    end
  end

end
