class CreditCardsController < ApplicationController

  before_action :require_current_user, :only => [:edit, :update]

  def destroy

    if CreditCard.find(params[:id]).destroy!
      flash[:success] = "Card successfully deleted!"
    else
      flash[:danger] = "Card failed to be deleted - please try again"
    end

    redirect_to :back

  end

  def require_current_user

    unless current_user == CreditCard.find(params[:id]).user
      flash[:danger] = "Access denied."
      redirect_to root_path
    end

  end

end
