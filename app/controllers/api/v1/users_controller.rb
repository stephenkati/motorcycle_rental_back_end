class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      token = encoded_token({ user_id: @user.id })
      render json: { staus: 'Success', user: @user, token: }, status: :ok
    else
      render json: { staus: 'Error', message: 'Invalid credentials', errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: login_params[:username])

    if @user.nil?
      render json: { status: 'Error', message: 'Oops, User not found!' }, status: :unauthorized
    elsif !@user.authenticate(login_params[:password])
      render json: { status: 'Error', message: 'Invalid credentials' }, status: :unauthorized
    else
      token = encoded_token({ user_id: @user.id })
      render json: { status: 'Success', message: 'Successfully logged In', user: @user, token: }, status: :ok
    end
  end

  def login_params
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
