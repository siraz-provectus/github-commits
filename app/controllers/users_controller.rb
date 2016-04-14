class UsersController < ApplicationController
  expose :user, attributes: :user_params

  def edit
  end

  def update
    user.update!(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
