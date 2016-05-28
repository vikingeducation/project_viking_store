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
      flash[:success] = "You signed out"
      redirect_to products_path
    else
      flash[:danger] = "You cannot sign out, sorry"
      redirect_to products_path
    end
  end

  private

  def update_cart(user)

    if user.get_cart?
      o = user.cart
      session[:user_cart].each do |product|
        if o.products && o.product_ids.include?(product.to_i)
          OrderContent.where(order_id: o.id, product_id: product.to_i).first.quantity += 1
        else
          oc = OrderContent.create(:order_id => o.id, :product_id => product.to_i)
        end
      end
    else
      o = Order.create(:user_id => user.id)
      session[:user_cart].each do |product|
        oc = OrderContent.create(:order_id => o.id, :product_id => product.to_i)
      end
    end
  end

end
