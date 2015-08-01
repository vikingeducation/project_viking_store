class UsersController < ApplicationController
  def new
    @user = User.new
    2.times do
      @user.addresses.build
    end
  end

  def create
    @user = User.new(whitelisted_user_params)
    #result = begin_user_address_transaction
    if @user.save
      flash[:success] = "You've successfully signed up! Congratulations!"
      sign_in @user
      @user.merge_carts(session[:cart])
      session[:cart] = []
      redirect_to root_path
    else
      flash[:danger] = "There was an error saving your user."
      binding.pry
      render :new
    end
  end

  private
    def whitelisted_user_params
      params.require(:user).permit(:email, :email_confirmation,
                                   :first_name, :last_name,
                                   :shipping_id,
                                   :billing_id,
                                   {addresses_attributes: [:street_address,
                                                           :zip_code,
                                                           :city_id,
                                                           :state_id]})
    end

    def begin_user_address_transaction
      begin
        ActiveRecord::Base.transaction do
          @user.save!
          @user.rebuild_user_addresses(params[:address])
        end
      rescue
        return "There was an error in your form. No changes have been made."
      end
      return nil
    end
end
