class CartsController < ApplicationController

  def create
    session[:cart] ||= {}
    item = params[:item]

    if Product.exists?(item) && session[:cart][item]
      session[:cart][item] += 1
      flash[:success] = "Added another to your cart."
    elsif Product.exists?(item)
      session[:cart][item] = 1
      flash[:success] = "#{Product.find(item).name} added to cart!"
    else
      flash[:error] = "Product is invalid"
    end

    # preserves an existing product filter if you have one
    # passed to this action via hidden field
    redirect_to products_path({products_filter: params[:products_filter]})
  end

  def edit
    @cart = session[:cart]
    @total = 0
    if @cart
      @cart.each do |product_id, quantity|
        @total += Product.find(product_id).price * quantity
      end
    end
  end

  def update
    @cart = session[:cart]

    params[:order].each do |product_id, quantity|
      session[:cart][product_id] = quantity.to_i
      session[:cart].delete(product_id) if quantity == ("0" || "")
    end

    if params[:remove]

      params[:remove].each do |product_id, _true|
        session[:cart].delete(product_id)
      end

    end

    flash[:success] = "Updated your order quantities."
    render :edit
  end

  def destroy
    session.delete(:cart)
    flash[:success] = "Cart deleted!"
    redirect_to root_path
  end

end
