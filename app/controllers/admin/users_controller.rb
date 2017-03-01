class Admin::UsersController < ApplicationController
  layout 'admin'
  def index
    @users = User.all.order('id')
    render locals: { rows: @users, headings: ['id', 'name', 'joined', 'city', 'state', 'orders', 'last order date']}
  end

  def new
  end

  def create
  end
end
