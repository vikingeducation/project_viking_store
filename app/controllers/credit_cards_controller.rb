class CreditCardsController < ApplicationController

  def destroy
    @cc = CreditCard.find(params[:id])
    @cc.destroy
    redirect_to user_path(params[:user_id])
  end


  
end
