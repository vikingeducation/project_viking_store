class CreditCardsController < ApplicationController
  def destroy
    credit_card = CreditCard.find(params[:id])
    if credit_card
      credit_card.destroy
      flash[:success] = "credit_card #{credit_card.card_number} deleted!"
      redirect_to user_path(credit_card[:user_id])
    else
      redirect_to session.delete(:return_to)
    end
  end
end
