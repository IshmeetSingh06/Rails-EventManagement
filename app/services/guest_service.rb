class GuestService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:params]
    self.current_user = params[:current_user]
  end

  def register
    user = User.new(params)
    if user.save
      self.authentication_token = user.authentication_token
      user.serializable_hash(except: [:authentication_token, :active])
    else
      self.errors = user.errors.full_messages
    end
  end

  def update
    if current_user.authenticate(params["password"])
      self.errors = current_user.errors.full_messages unless current_user.update(params)
      current_user.serializable_hash(except: :active) if self.errors.blank?
    else
      self.errors = "Wrong Password"
    end
  end

  def attended_events
    current_user.attended_events
  end

  def register_event_attendee(event_id)
    event = Event.find_by(id: event_id)
    if event.blank?
      self.errors = "Event not found"
    elsif event.capacity > event.registrations.count
      registration = Registration.new(user_id: current_user.id, event_id: event_id)
      self.errors = registration.errors.full_messages unless registration.save
      event if self.errors.blank?
    else
      self.errors = "Capacity Full, better luck next time"
    end
  end
end
