require 'rails_helper'

describe "GET / returns root", :type => :request do
  before {get '/'}

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end