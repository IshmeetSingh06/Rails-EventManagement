class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :require_admin, only: [:create]

  def create
    result = UsersService.new(user_params)
    result.register_user
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { token: result.authentication_token, message: "User Created Successfully" }, status: :created
    end
  end

  def update
    result = UsersService.new(user_params)
    result.update_user(@current_user)
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { token: result.authentication_token, message: "User Updated Successfully" }, status: :created
    end
  end

  private
  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name, :role)
  end

  private
  def require_admin
    unless @current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
