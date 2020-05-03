# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module AuthHelpers
    def authenticated_header
      token = Knock::AuthToken.new(payload: { sub: current_user.id }).token
      { 'Authorization': "Bearer #{token}" }
    end

    def admin_authenticated_header
      token = Knock::AuthToken.new(payload: { sub: admin_current_user.id }).token
      { 'Authorization': "Bearer #{token}" }
    end

    def current_user
      @current_user ||= FactoryBot.create(:user)
    end

    def admin_current_user
      @admin_current_user ||= FactoryBot.create(:user, role: 'admin')
    end
  end
end
