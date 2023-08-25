class EventsService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:params]
    self.current_user = params[:current_user]
  end

  def create
    event = Event.new(params.merge(organizer: current_user))
    self.errors = event.errors.full_messages unless event.save
  end

  def update(id)
    event = Event.find_by(id: id)
    if event.blank?
      self.errors = "Event not found"
    else
      self.errors = event.errors.full_messages unless event.update(params)
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
    event ? event.registrations : self.errors = "Event not found"
  end
end
