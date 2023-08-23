class Api::V1::EventsController < ApplicationController
  before_action :require_admin

  def create
    result = EventsService.new(event_params: event_params, current_user: current_user)
    result.create_event
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Created Successfully" }, status: :created
    end
  end

  def update
    result = EventsService.new(event_params: event_params)
    result.update_event(params[:id])
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Updated Successfully" }, status: :created
    end
  end

  def cancel
    result = EventsService.new
    result.cancel_event(params[:id])
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Cancelled Successfully" }, status: :ok
    end
  end

  private
  def event_params
    params.permit(:name, :description, :location, :time, :capacity)
  end

  private
  def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
