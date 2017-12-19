class Admin::CreditCardsController < AdminController

  def destroy
    @credit_card = CreditCard.find(params[:id])
    user_id = User.find(params[:user_id])
    @credit_card.destroy
    flash[:alert] = "#{@credit_card.nickname} has been deleted. I hope you're happy, 'cause, there's no undo."
    redirect_to admin_user_path(user_id)
  end

end
