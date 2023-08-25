class UsersService
  attr_accessor :errors

  def initialize
    self.errors = {}
  end

  def deactivate(id)
    user = User.find_by(id: id)
    if user.blank?
      self.errors = "User not found"
    else
      self.errors = user.errors.full_messages unless user.update!(active: false)
    end
  end

  def list_all
    User.all
  end
end
