class SessionsController < ApplicationController
  layout "shop"

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      update_cart(user) unless session[:user_cart].nil?
      signin( user )
      flash[:success] = "Welcome #{user.full_name}"
      redirect_to products_path
    else
      flash.now[:danger] = "Something went wrong"
      render :new
    end
  end

  def destroy
    if signout
      reset_session
      flash[:success] = "You signed out"
      redirect_to products_path
    else
      flash.now[:danger] = "You cannot sign out, sorry"
      redirect_to(:back)
    end
  end

  private

  def update_cart(user)
    user.get_cart? ? (o = user.cart) : (o = Order.create(:user_id => user.id))

     session[:user_cart].each do |product, quantity|
      product = product.to_i

      if o.products && o.product_ids.include?(product)
        OrderContent.where(order_id: o.id, product_id: product).first.quantity += quantity
      else
        oc = OrderContent.create(:order_id => o.id, :product_id => product, :quantity => quantity)
      end
    end
  end

end
