module Error
  module ErrorHandler
    def render_error_response(status, error, message)
      render json: { 
        status: status,
        error: error,
        message: message, 
      }, status: status
    end

    def render_not_found_response(exception)
      render_error_response(404, :not_found, exception.message)
    end

    def render_unprocessable_entity_response
      render_error_response(422, :unprocessable_entity, 'Cannot process entity for some reason')
    end

    def render_conflict_response
      render_error_response(409, :conflict, 'This entity already exists')
    end
  end
end
