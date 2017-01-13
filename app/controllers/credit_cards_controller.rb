class CreditCardsController < ApplicationController

  def destroy
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "Success!"
      redirect_to(:back)
    else
      flash[:warning] = "Error!"
      redirect_to(:back)
    end
  end

end
