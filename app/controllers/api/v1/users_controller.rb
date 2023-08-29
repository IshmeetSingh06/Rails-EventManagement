class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :require_admin, only: [:deactivate, :index]

  def create
    service = GuestService.new(params: user_params)
    user = service.register
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        {
          sucess: true,
          token: service.authentication_token,
          message: "User Created Successfully",
          user_details: user
        },
        status: :created
    end
  end

  def update
    service = GuestService.new(params: user_params, current_user: current_user)
    user = service.update
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        {
          sucess: true,
          message: "User Updated Successfully",
          user_details: user
        },
        status: :ok
    end
  end

  def deactivate
    service = UsersService.new
    service.deactivate(params[:id])
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, message: "User Deactivated Successfully" }, status: :ok
    end
  end

  def events
    service = GuestService.new(current_user: current_user)
    events = service.attended_events
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, events: events }, status: :ok
    end
  end

  def attend_event
    service = GuestService.new(current_user: current_user)
    event = service.register_event_attendee params[:event_id]
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        {
          sucess: true,
          message: "Registered for event with id = #{params[:event_id]}",
          event_details: event
        },
        status: :ok
    end
  end

  def index
    service = UsersService.new
    users = service.list_all
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, users: users }, status: :ok
    end
  end

  private def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :email)
  end

  private def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
