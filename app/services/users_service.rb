class UsersService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:user_params]
    self.current_user ||= params[:current_user]
  end

  def register
    user = User.create(params)
    if user.created_at?
      self.authentication_token = user.authentication_token
    else
      self.errors = user.errors.full_messages
    end
  end

  def update
    unless current_user.update(params)
      self.errors = current_user.errors.full_messages
    end
  end

  def deactivate(id)
    user = User.find_by(id: id)
    if user
      user.update!(active: false)
    else
      self.errors = user.errors.full_messages
    end
  end

  def attended_events
    current_user.attended_events
  end

  def register_event_attendee(event_id)
    event = Event.find_by(id: event_id)
    if event
      if event.capacity > event.registrations.count
        Registration.create!(user_id: current_user.id, event_id: event_id)
        event
      else
        self.errors = "Capacity Full, better luck next time"
      end
    else
      self.errors = "Event not found"
    end
  end

  def list_all
    User.all
  end
end
