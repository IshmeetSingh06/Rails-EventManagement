class UsersController < ApplicationController
  def create
    user = UserService.register_user(user_params)
    if user.valid?
      render json: { token: user.authentication_token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = UserService.login(params[:username], params[:password])
    if user
      render json: { token: user.authentication_token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:username, :password, :first_name, :last_name, :role)
  end
end
