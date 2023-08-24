class ApplicationController < ActionController::API
  before_action :authenticate_user

  attr_accessor :current_user

  private def authenticate_user
    token = request.headers['Authorization']
    user = User.active.find_by(authentication_token: token)
    if user
      self.current_user = user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
