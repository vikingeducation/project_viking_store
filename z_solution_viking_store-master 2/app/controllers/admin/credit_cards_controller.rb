class Admin::CreditCardsController < AdminController
  def destroy
  	@credit_card = CreditCard.find(params[:id])
    @credit_card.destroy
    redirect_to edit_order_path
  end
end
