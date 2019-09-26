class ApplicationController < ActionController::API
  include Error::ErrorHandler

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordNotUnique, with: :render_conflict_response

end
