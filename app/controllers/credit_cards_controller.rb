class CreditCardsController < ApplicationController
  def destroy
    credit_card = CreditCard.find(params[:id])
    user = credit_card.user

    if credit_card.destroy
      flash[:success] = "Credit card successfully deleted."
      redirect_to user
    else
      flash[:error] = "Error deleting credit card."
      redirect_to :back
    end
  end
end
