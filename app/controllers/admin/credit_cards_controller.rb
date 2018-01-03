class Admin::CreditCardsController < ApplicationController

  def index
  end


  def new
    @user = User.find(params[:user_id])
    @cc = CreditCard.new
  end


  def create
    @cc = CreditCard.new(whitelisted_params)
    if @cc.save
      render 'user/:id/show'
    else
      redirect_to :new
    end
  end


  def show
  end


  def edit
  end


  def update
  end


  def destroy
  end



  private


  def whitelisted_params
    params.require(:credit_card).permit(:id, :card_number, :exp_month, :exp_year, :brand, :user_id, :ccv)
  end

end
