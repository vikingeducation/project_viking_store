class CreditCardsController < ApplicationController
  def destroy
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "Card obliterated!"
      redirect_to user_path(@credit_card.user_id)
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/products"
    end
  end
end
