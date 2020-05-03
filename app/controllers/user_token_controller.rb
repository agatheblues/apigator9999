# frozen_string_literal: true

class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token
  before_action :verify_user_confirmed

  private

  def verify_user_confirmed
    user = User.find_by(email: params[:auth][:email])
    head :unauthorized unless user.confirmed?
  end
end
