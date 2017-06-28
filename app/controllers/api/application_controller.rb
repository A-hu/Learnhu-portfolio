class Api::ApplicationController < DeviseTokenAuth::ApplicationController

  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActionView::MissingTemplate, with: :permission

  private

  def permission
    render json: { message: 'Permission denied' }, status: 401
  end
end
