class UsersController < ApplicationController
  def create
    result = UserService.register_user(user_params)
    if result.is_a?(User)
      render json: { message: "User Created Successfully" }, status: :created
    else
      render json: result, status: :unprocessable_entity
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
    params.permit(:username, :email, :password, :first_name, :last_name, :role)
  end
end
