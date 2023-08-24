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

  def index
    result = EventsService.new
    events = result.list_all
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "No ongoing events" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  def list_all_organized
    result = EventsService.new(current_user: current_user)
    events = result.list_all_organized
    if result.errors.present?
      render json: { errors: result.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "No organized events" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  private
  def event_params
    params.permit(:name, :description, :location, :time, :capacity)
  end

  private
  def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
