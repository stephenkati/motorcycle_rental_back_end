class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      token = encoded_token({ user_id: @user.id })
      render json: { user: @user, token: }, status: :ok
    else
      render json: { message: 'Invalid credentials' }
    end
  end

  def login
    @user = User.find_by(username: login_params[:username])

    if @user&.authenticate(login_params[:password])
      token = encoded_token({ user_id: @user.id })
      render json: { user: @user, token: }, status: :ok
    else
      render json: { message: 'Invalid credentials' }
    end
  end

  def login_params
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
