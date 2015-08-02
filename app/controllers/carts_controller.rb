class CartsController < ApplicationController
  before_filter :require_login, only: [:checkout]
  def update
    if current_user
      update_database_cart
    else
      if params["product_id"]
        update_session_cart
        redirect_to root_path
      else
        session[:cart] = parse_edited_cart(params[:edited_cart])
        flash[:success] = "Your cart has been updated."
        redirect_to edit_carts_path
      end
    end
    redirect_to root_path
  end

  def edit
    if current_user
      cart = current_user.cart || Order.new(user: current_user)
      render :db_cart_form, locals: {order: cart}
    else
      render :session_cart_form, locals: {order: session[:cart]}
    end
  end

  def checkout
    @user = current_user
    @cc = @user.first_credit_card
  end

  def finalize_order
    @order = current_user.cart
    @order.checkout_date = Time.now
    if @order.save
      flash[:success] = "You've successfully placed your order!"
      current_user.get_new_cart
      redirect_to root_path
    else
      binding.pry
      @order.checkout_date = nil
      flash[:success] = "We failed to place your order. Please Try Again."
      redirect_to checkout_path
    end
  end

  def destroy
    if current_user
      current_user.cart.destroy
      current_user.get_new_cart
    else
      session[:cart] = []
    end
    flash[:notice] = "Your cart has been emptied."
    redirect_to root_path
  end

  private

    def update_session_cart
      cart = session[:cart]

      product_id, quantity = params["product_id"], params["quantity"].to_i
      if product = cart.find{|value| value["product_id"] == product_id}
        if quantity == 0
          flash[:notice] = "Product removed from cart."
          cart.delete(product)
        else
          flash[:notice] = "Product Quantity Updated!"
          product[:quantity] = quantity
        end
      else
        flash[:notice] = "Product Added to Cart!"
        cart << {product_id: product_id, quantity: quantity}
      end

      session[:cart] = cart
    end

    def update_database_cart
      cart = current_user.cart
      product_id, quantity = params["product_id"], params["quantity"].to_i
      if product = cart.order_contents.find_by(product_id: product_id)
        if quantity == 0
          flash[:notice] = "Product removed from cart."
          product.destroy
        else
          flash[:notice] = "Product Quantity Updated!"
          product.update(quantity: quantity)
        end
      else
        flash[:notice] = "Product Added to Cart!"
        cart.order_contents.create(product_id: product_id, quantity: quantity)
      end
    end

    def parse_edited_cart(cart)
      parsed_cart = []
      cart.each do |key, value|
        parsed_cart << value unless value["quantity"].to_i <= 0
      end
      parsed_cart
    end
end
