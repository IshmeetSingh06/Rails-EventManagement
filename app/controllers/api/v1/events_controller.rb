class Api::V1::EventsController < ApplicationController
  before_action :require_admin, except: [:upcoming]

  def create
    service = EventsService.new(params: event_params, current_user: current_user)
    service.create
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Created Successfully" }, status: :created
    end
  end

  def update
    service = EventsService.new(params: event_params)
    service.update(params[:id])
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Updated Successfully" }, status: :created
    end
  end

  def cancel
    service = EventsService.new
    service.cancel(params[:id])
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    else
      render json: { message: "Event Cancelled Successfully" }, status: :ok
    end
  end

  def index
    service = EventsService.new
    events = service.list_all
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "No events found" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  def organized
    service = EventsService.new(current_user: current_user)
    events = service.list_all_organized
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "No organized events" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  def registrations
    service = EventsService.new
    registrations = service.list_registrations(params[:id])
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif registrations.blank?
      render json: { message: "No registrations for this event" }, status: :ok
    else
      render json: registrations, status: :ok
    end
  end

  def upcoming
    service = GuestService.new
    events = service.list_upcoming_events(params[:page].to_i)
    if service.errors.present?
      render json: { errors: service.errors }, status: :unprocessable_entity
    elsif events.blank?
      render json: { message: "No Upcoming events" }, status: :ok
    else
      render json: events, status: :ok
    end
  end

  private def event_params
    params.permit(:name, :description, :location, :time, :capacity)
  end

  private def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
