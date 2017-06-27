class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> {request.format.json?}
  include DeviseWhitelist
  include SetSource
  include CurrentUserConcern
  include DefaultPageContent
end
