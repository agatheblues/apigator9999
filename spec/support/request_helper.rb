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

    def current_user
      @user ||= FactoryBot.create(:user)
    end
  end
end