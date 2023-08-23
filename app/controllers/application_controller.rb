class ApplicationController < ActionController::API
  before_action :authenticate_user

  attr_accessor :current_user

  private
  def authenticate_user
    begin
      token = request.headers['Authorization']
      user = User.find_by!(authentication_token: token)
      if user.active?
        self.current_user ||= user
      else
        render json: { error: 'User deactivated, contact admin' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound=> error
      render json: { error: "No User Associated with the token" }, status: :unprocessable_entity
    end
  end
end
