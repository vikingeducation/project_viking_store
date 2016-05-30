class ShoppingCartsController < ApplicationController
  layout "shop"

  def edit
    @cart = current_user.cart if signed_in_user?
  end

  private

end
