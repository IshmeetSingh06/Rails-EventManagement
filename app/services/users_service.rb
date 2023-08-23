class UsersService
  attr_accessor :errors, :authentication_token, :params

  def initialize(params)
    self.errors = {}
    self.params = params
  end

  def register_user
    user = User.new(params)
    if user.save
      self.authentication_token = user.authentication_token
    else
      self.errors = user.errors.full_messages
    end
  end

  def update_user(current_user)
    if current_user.update!(params)
      self.authentication_token = current_user.authentication_token
    else
      self.errors = current_user.errors.full_messages
    end
  end

  def deactivate_user(user_id)
    begin
      user = User.find(user_id)
      user.update!(active: false)
    rescue ActiveRecord::RecordNotFound => error
      self.errors = error.message
    rescue ActiveRecord::RecordInvalid => error
      self.errors = user.errors.full_messages
    end
  end
end
