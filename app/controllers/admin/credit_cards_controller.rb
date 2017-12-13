class CreditCardsController < AdminController

  def destroy
    session[:return_to] ||= request.referer

    binding.pry # THIS DOESNT WORK
    @credit_card = CreditCard.find(params[:id])
    @credit_card.destroy
    flash[:alert] = "#{@credit_card.nickname} has been deleted. I hope you're happy, 'cause, there's no undo."
    redirect_to session.delete(:return_to)
  end

end
