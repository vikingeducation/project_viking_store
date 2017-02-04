class UsersController < ApplicationController

	include UsersHelper

	def index
		@users = User.order(:id)
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
		@edit_form = false
	end

	def create
		@user = User.new(users_params)
		if @user.save
			flash[:success] = "User created successfully"
			redirect_to users_path
		else
			flash[:error] = "User creation failed"
			render action: "new"
		end
	end

	def edit
		@user = User.find(params[:id])
		@edit_form = true
	end

	def update
		@user = User.find(params[:id])
		if @user.update(users_params)
			flash[:success] = "Great! Your user has been updated!"
			redirect_to users_path
		else
			flash[:error] = "Could not update!"
			render action: "edit"
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			flash[:success] = "Great! Your user has been removed!"
			redirect_to users_path
		else
			flash[:error] = "Could not remove user!"
			redirect_to(:back)
		end
  	end

end
