class UsersService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:user_params]
    self.current_user = params[:current_user]
  end

  def register_user
    begin
      user = User.create!(params)
      self.authentication_token = user.authentication_token
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    rescue ArgumentError => error
      self.errors = error
    else
      self.errors = user.errors.full_messages
    end
  end

  def update_user
    begin
      current_user.update!(params)
      self.authentication_token = current_user.authentication_token
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    else
      self.errors = current_user.errors.full_messages
    end
  end

  def deactivate_user(user_id)
    begin
      user = User.find(user_id)
      user.update!(active: false)
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    else
      self.errors = user.errors.full_messages
    end
  end

  def list_all_events
    begin
      current_user.attended_events
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    else
      self.errors = current_user.errors.full_messages
    end
  end

  def register_event(event_id)
    begin
      event_from_id = Event.find(event_id)
      if event_from_id.capacity > event_from_id.registrations.count
        Registration.create!(user_id: current_user.id, event_id: event_id)
        event_from_id
      else
        self.errors = "Capacity Full, better luck next time"
      end
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    rescue ActiveRecord::RecordInvalid => error
      self.errors = error
    end
  end

  def list_all
    begin
      User.all
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error
    end
  end
end
