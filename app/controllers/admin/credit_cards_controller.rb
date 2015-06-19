class Admin::CreditCardsController < AdminController
  def destroy
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "Card obliterated!"
      redirect_to admin_user_path(@credit_card.user_id)
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/admin/products"
    end
  end
end
