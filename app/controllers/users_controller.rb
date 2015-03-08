class UsersController < ApplicationController

  layout "admin", only: [:index, :new, :show, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @credit_cards = @user.credit_cards
  end
end
