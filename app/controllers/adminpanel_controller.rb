class AdminpanelController < ApplicationController

  def index
    @headers=["ID","Name","Joined","City","Status","Orders","Order date", "SHOW", "EDIT","DELETE"]

  end

  def new
    @user=User.new
    flash.notice = "New user created"
  end

  def create
    flash.notice = "New user created"

  end
end
