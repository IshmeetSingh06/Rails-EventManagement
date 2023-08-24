class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :require_admin, only: [:deactivate, :list_all]

  def create
    result = UsersService.new(user_params: user_params)
    result.register_user
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json:
        { token: result.authentication_token, message: "User Created Successfully" },
        status: :created
    end
  end

  def update
    result = UsersService.new(user_params: user_params, current_user: current_user)
    result.update_user
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { message: "User Updated Successfully" }, status: :created
    end
  end

  def deactivate
    result = UsersService.new
    result.deactivate_user(params[:id])
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { message: "User Deleted Successfully" }, status: :ok
    end
  end

  def list_events
    result = UsersService.new(current_user: current_user)
    events = result.list_all_events
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "Not registered in any event!" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  def register
    result = UsersService.new(current_user: current_user)
    event = result.register_event params[:event_id]
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json:
      { message: "Registered for event with id = #{params[:event_id]}", event_details: event},
      status: :ok
    end
  end

  def index
    result = UsersService.new
    users = result.list_all
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: users, status: :ok
    end
  end

  private
  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name)
  end

  private
  def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
