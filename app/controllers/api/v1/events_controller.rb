class Api::V1::EventsController < ApplicationController
  before_action :require_admin, except: [:upcoming]

  def create
    service = EventsService.new(params: event_params, current_user: current_user)
    event = service.create
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        {
          sucess: true,
          message: "Event Created Successfully",
          event_details: event
        },
        status: :created
    end
  end

  def update
    service = EventsService.new(params: event_params)
    event = service.update(params[:id])
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json:
        {
          sucess: true,
          message: "Event Updated Successfully",
          event_details: event
        },
        status: :ok
    end
  end

  def cancel
    service = EventsService.new
    service.cancel(params[:id])
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, message: "Event Cancelled Successfully" }, status: :ok
    end
  end

  def index
    service = EventsService.new
    events = service.list_all
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, events: events }, status: :ok
    end
  end

  def organized
    service = EventsService.new(current_user: current_user)
    events = service.list_all_organized
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, events: events }, status: :ok
    end
  end

  def registrations
    service = EventsService.new
    registrations = service.list_registrations(params[:id])
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, registrations: registrations }, status: :ok
    end
  end

  def upcoming
    service = GuestService.new
    events = service.list_upcoming_events(params[:page].to_i)
    if service.errors.present?
      render json: { sucess: false, errors: service.errors }, status: :unprocessable_entity
    else
      render json: { sucess: true, events: events }, status: :ok
    end
  end

  private def event_params
    params.require(:event).permit(:name, :description, :location, :time, :capacity)
  end

  private def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
