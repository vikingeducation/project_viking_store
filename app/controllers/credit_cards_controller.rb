class CreditCardsController < ApplicationController

  def destroy
    CreditCard.find(params[:id]).destroy
    flash[:alert] = "Credit Card has been destroyed!"
    redirect_to :back
  end

end
