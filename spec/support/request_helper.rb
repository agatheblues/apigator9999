module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module AuthHelpers
    def authenticated_header
      user = FactoryBot.create(:user)
      token = Knock::AuthToken.new(payload: { sub: user.id }).token
      { 'Authorization': "Bearer #{token}" }
    end
  end
end