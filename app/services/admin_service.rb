class AdminService
  attr_accessor :errors, :authentication_token, :params, :current_user

  def initialize(params = {})
    self.errors = {}
    self.params = params[:user_params]
    self.current_user = params[:current_user]
  end

  def deactivate_user(id)
    user = User.find_by(id: id)
    if user.blank?
      self.errors = "User not found"
    else
      self.errors = user.errors.full_messages unless user.update!(active: false)
    end
  end

  def list_all_users
    User.all
  end
end
