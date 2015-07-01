class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
    2.times { @user.addresses.build }
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Updated your profile!"
      render :edit
    else
      flash[:error] = "Problem updating your profile! Please fix errors."
      render :edit
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create
    @user = User.create(user_params)
    if @user.save
      sign_in(@user)
      flash[:success] = "Account created!"
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :billing_id,
                                 :shipping_id,
                                 :password,
                                 :password_confirmation,
                                 :addresses_attributes => [
                                   :id,
                                   :street_address,
                                   :zip_code,
                                   :city_id,
                                   :state_id ] )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
