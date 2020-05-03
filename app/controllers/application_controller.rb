# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include Knock::Authenticable

  before_action :authenticate_user
  before_action :verify_user_confirmed

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordNotUnique, with: :render_conflict_response

  protected

  # Method for checking if current_user is admin or not.
  def authorize_as_admin
    head :unauthorized unless !current_user.nil? && current_user.admin?
  end

  def verify_user_confirmed
    head :unauthorized unless current_user.confirmed?
  end
end
