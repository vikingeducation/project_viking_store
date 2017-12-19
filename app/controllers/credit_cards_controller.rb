class CreditCardsController < ApplicationController

  def new
    @credit_card = CreditCard.new
    session[:return_to] ||= request.referer
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)
    if @credit_card.save
      flash[:notice] = "Credit Card #{@credit_card.nickname} has been saved."
      redirect_to session.delete(:return_to)
    else
      flash.now[:error] = "Whoopsiedumpskies. Gotta fix some stuff below."
      render :new
    end
  end

  def destroy
    flash[:alert] = "Has not been implemented yet."
  end

  private

  def credit_card_params
    params.require(:credit_card).permit(:nickname, :card_number, :exp_month,  :exp_year, :brand, :ccv, :user_id)
  end
end
