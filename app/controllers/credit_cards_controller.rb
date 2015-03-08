class CreditCardsController < ApplicationController

  def destroy
    @credit_card = CreditCard.find(params[:id])
    session[:return_to] ||= request.referer
    if @credit_card.destroy!
      flash[:success] = "That credit card was deleted."
      redirect_to users_path(params[:user_id])
    else
      flash[:error] = "It didn't work."
      redirect_to session.delete(:return_to)
    end
  end

end
