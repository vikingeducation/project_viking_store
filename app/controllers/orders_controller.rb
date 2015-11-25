class OrdersController < ApplicationController
  before_action :require_login, only: [:checkout]
  before_action :force_merge, only: [:checkout]

  # Create action is only triggered by adding product to cart from index
  # Check if the user is signed in and then if we need to create a cart
  # If no user, use session cart

  def create
    @user = current_user
    if @user && !session[:cart]
      @cart = @user.cart ? @user.cart : @user.orders.new
      @cart.order_contents.build(product_id: product_params[:id])
      if @cart.save
        flash[:info] = "Shopping cart updated"
      else
        flash[:danger] = "Oops, something went wrong!"
      end
    else session[:cart]
      update_session_cart
      flash[:info] = "Shopping cart updated"
    end
    redirect_to products_path(category: params[:category])
  end

  # Edit page renders form using @cart.  We have to run a few checks on the 
  # user to avoid setting @cart when there isn't one or its empty
  # If no user, we build @cart from the session[:cart]

  # We're also looking for the case when we need to prompt the user on
  # merging carts
  def edit
    @user = current_user
    if items_in_cart?(@user) && session[:cart]
      merge_carts_prompt
      build_cart_from_session
    elsif @user && session[:cart]
      merge_carts
    elsif session[:cart]
      build_cart_from_session
    elsif items_in_cart?(@user)
      @cart = @user.cart
    end
  end


  def update
    @user = current_user
    if @user && !session[:cart]
      @cart = Order.find(order_params[:id])
      if @cart.update(order_params)
        flash[:info] = "Shopping Cart Updated."
      else
        flash[:danger] = "Oops, something went wrong!"
      end
    else session[:cart]
      update_session_cart
      flash[:info] = "Shopping Cart Updated."
    end    
    redirect_to shopping_cart_path
  end


  def checkout
    
  end


  def merge_or_discard_cart
    @user = current_user
    case params[:merge]
    when "combine"
      flash[:info] = "Carts combined!"
      merge
    when "discard_saved"
      flash[:info] = "Saved shopping cart discarded."
      @user.cart.destroy
      merge
    when "discard_current"
      flash[:info] = "Current shopping cart discarded, here is your saved cart."
      session.delete(:cart)
    end
    redirect_to shopping_cart_path
  end


  private

  # Build a sort of preview of the saved cart, presense of the variable
  # causes the prompt to render on the edit page.
  def merge_carts_prompt
    @saved_cart_preview = @user.cart.products.take(3)
  end

  # Unpack session[:cart] into order object to render edit/shopping_cart form
  def build_cart_from_session
    @cart = Order.new
    session[:cart].each do |p_id, q|
      @cart.order_contents.build(product_id: p_id, quantity: q)
    end
  end

  # Load and save session cart
  def update_session_cart
    @session_cart = Hash.new(0)
    @session_cart.merge!(session[:cart]) if session[:cart] 

    params_to_cart

    session[:cart] = @session_cart
    session.delete(:cart) if @session_cart.empty?
  end

  # Update session cart, different methods for (nested) order contents
  # from shopping cart screen vs products added from home page.
  def params_to_cart
    if params.key?(:order)
      order_params[:order_contents_attributes].each do |k, param|
        if Product.find_by_id(param["product_id"])
          @session_cart[param["product_id"]] = param["quantity"]
        end
        remove_item?(param)
      end

    elsif params.key?(:product) && Product.find_by_id(product_params[:id])
      @session_cart[product_params[:id]] += 1
    end
  end

  # Handle removing product from session if quantity 0 or _destroy is checked.
  def remove_item?(param)
    if param["_destroy"] == "1" || param["quantity"] == "0"
      @session_cart.delete(param["product_id"])
    end
  end


  # Merge carts and delete the session[:cart]
  def merge
    if @user.cart
      @cart = @user.cart
    else
      @cart = @user.orders.new
    end

    session[:cart].each do |product_id, quantity|
      @cart.order_contents.build(product_id: product_id, quantity: quantity)
    end

    if @cart.save
      session.delete(:cart)
    end
  end

  # We need to force the user to make a choice about their cart before
  # checking out.
  def force_merge
    if session[:cart]
      flash[:danger] = "Please combine or discard shopping carts before check out!"
      redirect_to shopping_cart_path
    end
  end


  def order_params
    params.require(:order).permit(:id, :shipping_id, :billing_id, :credit_card_id, 
                                  :user_id, :status, order_contents_attributes: 
                                  [:quantity, :product_id, :id, :_destroy])
  end


  def product_params
    params.require(:product).permit(:id)
  end


end
