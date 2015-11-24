class SessionController < ApplicationController

  def new
  end


  def create
    store_location
    user = User.find_by_email(params[:session][:email])
    if user
      sign_in user
      merge_cart if session[:cart]
      flash[:success] = "Welcome back, #{user.first_name.capitalize}!"
      redirect_back_or(root_path)
    else
      flash.now[:danger] = "Sorry, we couldn't sign you in!"
      render :new
    end
  end


  def destroy
    if sign_out
      flash[:info] = "You have signed out"
      redirect_to root_path
    else
      flash[:error] = "You can't leave, she won't let you."
      redirect_to :back
    end
  end


  private


  def session_params
    params.require(:session).permit(:email, :password)
  end

  # When a user signs in we need to merge the session[:cart] with any existing
  # cart or create a cart for the user.
  def merge_cart
    # Ask user?
    user = current_user
    if user.cart
      @cart = user.cart
    else
      @cart = user.orders.new
    end

    session[:cart].each do |product_id, quantity|
      @cart.order_contents.build(product_id: product_id, quantity: quantity)
    end

    if @cart.save
      session.delete(:cart)
    end
  end


end
