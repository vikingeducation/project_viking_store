class Admin::CreditCardsController < ApplicationController

  def destroy
    @card = CreditCard.find(params[:id])
    @user = @card.user
    if @card.destroy
      flash.now[:success] = 'Card destroyed.'
      redirect_to admin_user_path(@user)
    else
      flash.now[:error] = 'Failed to destroy card.'
    end
  end
end