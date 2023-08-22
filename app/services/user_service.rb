class UserService
  class << self
    def register_user(user_params)
      user = User.new(user_params)
      user.authentication_token = generate_auth_token
      if user.save
        user
      else
        { errors: user.errors.full_messages }
      end
    end

    def login(username, password)
      user = User.find_by(username: username)
      if user && user.authenticate(password)
        user.authentication_token = generate_auth_token
        user.save
        user
      else
        nil
      end
    end

    private
    def generate_auth_token
      SecureRandom.hex(32)
    end
  end
end
