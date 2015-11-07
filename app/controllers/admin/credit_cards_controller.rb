class Admin::CreditCardsController < AdminController

  def destroy
    @card = CreditCard.find(params[:id])
    if @card.destroy
      flash[:warning] = "Saved Card '#{@card.nickname}' Deleted."
    else
      flash[:danger] = "Saved Card '#{@card.nickname} could not be deleted!"
    end
    redirect_to admin_user_path(@card.user_id)
  end

end
