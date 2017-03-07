class Admin::CreditCardsController < ApplicationController
  def destroy
    @card = CreditCard.find(params[:id])
    if @card.destroy
      flash[:success] = 'Success! The credit card was removed'
    else
      flash[:error] = 'Card not removed'
    end
    redirect_to admin_user_path(User.find(params[:user_id]))

  end
end
