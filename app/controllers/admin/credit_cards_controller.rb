class Admin::CreditCardsController < AdminController
  def destroy
  	@credit_card = CreditCard.find(params[:id])
    @user = @credit_card.user
    @credit_card.destroy
    redirect_to user_path(@user)
  end
end
