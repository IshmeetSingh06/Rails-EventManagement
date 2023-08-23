class ApplicationController < ActionController::API
  before_action :authenticate_user

  private
  def authenticate_user
    token = request.headers['Authorization']
    user = User.find_by(authentication_token: token)
    if user
      @current_user = user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
