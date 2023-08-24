class EventsService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:event_params]
    self.current_user ||= params[:current_user]
  end

  def create_event
    begin
      event = Event.new(params)
      event.organizer_id = current_user.id
      event.save!
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    rescue ArgumentError => error
      self.errors = error
    else
      self.errors = event.errors.full_messages
    end
  end

  def update_event(event_id)
    begin
      event = Event.find(event_id)
      event.update!(params)
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    else
      self.errors = event.errors.full_messages
    end
  end

  def cancel_event(event_id)
    begin
      event = Event.find(event_id)
      event.update!(cancelled: true)
      event.registrations.destroy_all
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    else
      self.errors = event.errors.full_messages
    end
  end

  def list_all
    begin
      Event.where(cancelled: false)
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    end
  end

  def list_all_organized
    begin
      current_user.organized_events
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    end
  end

  def list_registrations(event_id)
    begin
      Event.find(event_id).registrations
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    rescue ArgumentError => error
      self.errors = error
    end
  end
end
