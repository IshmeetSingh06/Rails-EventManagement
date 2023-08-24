class EventsService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:event_params]
    self.current_user = params[:current_user]
  end

  def create
    event = Event.new(params)
    event.organizer_id = current_user.id
    unless event.save
      self.errors = event.errors.full_messages
    end
  end

  def update(id)
    event = Event.find_by(id: id)
    if event
      unless event.update(params)
        self.errors = event.errors.full_messages
      end
    else
      self.errors = "Event not found"
    end
  end

  def cancel(id)
    event = Event.find_by(id: id)
    if event
      unless event.update(cancelled: true)
        self.errors = event.errors.full_messages
      end
    else
      self.errors = "Event not found"
    end
  end

  def list_all
    Event.all
  end

  def list_upcoming
    Event.active.upcoming
  end

  def list_all_organized
    current_user.organized_events
  end

  def list_registrations(id)
    event = Event.find_by(id: id)
    if event
      event.registrations
    else
      self.errors = "Event not found"
    end
  end
end
