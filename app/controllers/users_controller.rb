class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
  end

  def update
    success = if params[:guest]
      @user.make_guest!
      true
    else
      @user.update_capabilities(
        pilot: params[:pilot] == "1",
        passenger: params[:passenger] == "1"
      )
    end

    if success
      redirect_to "/user", notice: 'Capabilities updated successfully.'
    else
      redirect_to "/user", alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def set_user
    @user = current_user
  end
end 