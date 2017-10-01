class CreditCardsController < ApplicationController

  def index
    @credit_cardes = CreditCard.all
  end

  def new
    # @credit_card = CreditCard.new
  end

  def create
     @credit_card = CreditCard.new(credit_card_form_params)
    if @credit_card.save
      flash[:success] = "Credit Card created successfully."
      redirect_to user_credit_card_path(@credit_card)
    else
      flash[:error] = "Credit Card not created"
      render :index
    end
  end

  def show
    @credit_card = CreditCard.find(params[:id])
  end

  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  def update
     @credit_card = CreditCard.find(params[:id])
    if @credit_card.update_attributes(credit_card_form_params)
    flash[:success] = "CreditCard updated successfully."
    redirect_to user_credit_card_path(@credit_card)
    else
      flash[:error] = "CreditCard not updated"
      render :show
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "Credit Card deleted successfully."
      redirect_to users_path
    else
      flash[:error] = "Credit Card not deleted"
      redirect_to session.delete(:return_to)
    end
  end

  
  private
    def credit_card_form_params
      params.require(:credit_card).permit(:nickname, :card_number, :exp_month, :exp_year, :brand, :user_id, :ccv)
    end
end
