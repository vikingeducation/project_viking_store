class CreditCardsController < ApplicationController

  def destroy
    @card = CreditCard.find_by_id(params[:id])
    if @card.destroy
      flash[:warning] = "Saved Credit Card deleted."
      redirect_to checkout_path
    else
      flash[:danger] = "Could not delete saved Credit Card!"
      redirect_to checkout_path
    end
  end

end
