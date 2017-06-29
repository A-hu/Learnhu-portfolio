module Api
  class ApplicationController < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken

    protect_from_forgery with: :null_session
    respond_to :json

    # Permission from petergate which is without json responds
    rescue_from ActionView::MissingTemplate, with: :permission

    private

    def permission
      render json: { message: 'Permission denied' }, status: 401
    end
  end
end
