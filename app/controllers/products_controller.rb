class ProductsController < ApplicationController
  def index
    session[:cart] ||= [] unless current_user

    @selected = get_selected
    if @selected == "" || @selected == nil
      @products = Product.all
    else
      @products = Category.find(@selected).products
    end
  end

  private

    # If there's a category in the params, we set our session filter to it.
    # The reason for this is if they navigate to a category then try
    # updating their cart we still want them to go back to a filtered category.
    def get_selected
      if params[:category]
        session[:filter] = params[:category][:id]
      else
        session[:filter]
      end
    end
end
