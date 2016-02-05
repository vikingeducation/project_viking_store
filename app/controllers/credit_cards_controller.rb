class CreditCardsController < ApplicationController
  def destroy
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "You've Sucessfully Deleted the Credit Card!"
      redirect_to :back
    else
      flash.now[:error] = "Error! Credit Card wasn't deleted!"
      redirect_to :back
    end
  end
end
