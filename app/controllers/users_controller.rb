class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    if params[:guest]
      @user.make_guest!
    else
      @user.update_capabilities(
        pilot: params[:pilot] == "1",
        passenger: params[:passenger] == "1"
      )
    end

    redirect_to "/user", notice: 'Capabilities updated successfully.'
  end

  private

  def set_user
    @user = current_user
  end
end 