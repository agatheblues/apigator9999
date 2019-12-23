require 'rails_helper'

describe "GET / returns root", :type => :request do
  context 'when authenticated' do
    before {get '/', headers: authenticated_header}

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when unauthenticated' do
    before {get '/'}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end