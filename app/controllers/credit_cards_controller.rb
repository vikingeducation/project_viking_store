class CreditCardsController < ApplicationController

  def destroy

    @card = CreditCard.find(params[:id])

    if @card.destroy
      flash[:success] = "Card successfully removed!"
    else
      flash[:danger] = "Card failed to be removed - please try again."
    end

    redirect_to :back
    
  end

end
