class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :require_admin, only: [:deactivate, :index]

  def create
    service = UsersService.new(user_params: user_params)
    service.register
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        { token: service.authentication_token, message: "User Created Successfully" },
        status: :created
    end
  end

  def update
    service = UsersService.new(user_params: user_params, current_user: current_user)
    service.update
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json: { message: "User Updated Successfully" }, status: :created
    end
  end

  def deactivate
    service = UsersService.new
    service.deactivate(params[:id])
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json: { message: "User Deleted Successfully" }, status: :ok
    end
  end

  def events
    service = UsersService.new(current_user: current_user)
    events = service.attended_events
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "Not registered in any event!" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  def attend_event
    service = UsersService.new(current_user: current_user)
    event = service.register_event_attendee params[:event_id]
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json:
      { message: "Registered for event with id = #{params[:event_id]}", event_details: event},
      status: :ok
    end
  end

  def index
    service = UsersService.new
    users = service.list_all
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif users.blank?
      render json: { message: "No users are present" }, status: :ok
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
