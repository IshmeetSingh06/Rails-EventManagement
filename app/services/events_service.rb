class EventsService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:params]
    self.current_user = params[:current_user]
  end

  def create
    event = Event.new(params.merge(organizer: current_user))
    if event.save
      event
    else
      self.errors = event.errors.full_messages
    end
  end

  def update(id)
    event = Event.find_by(id: id)
    if event.blank?
      self.errors = "Event not found"
    elsif event.update(params)
      event
    else
      self.errors = event.errors.full_messages
    end
  end

  def cancel(id)
    event = Event.find_by(id: id)
    if event.blank?
      self.errors = "Event not found"
    else
      self.errors = event.errors.full_messages unless event.update(cancelled: true)
    end
  end

  def list_all
    Event.all
  end

  def list_all_organized
    current_user.organized_events
  end

  def list_registrations(id)
    event = Event.find_by(id: id)
    if event.blank?
      self.errors = "Event not found"
    else
      event.registrations
    end
  end
end
