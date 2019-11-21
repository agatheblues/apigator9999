require 'rails_helper'

describe "GET /styles gets all styles", :type => :request do
  let!(:styles) { 
    list = FactoryBot.create_list(:album, 10)
    styles = list.map { |album| album.styles}
    styles.flatten
  }

  before {get '/styles'}

  it 'returns all styles' do
    expect(json.size).to eq(styles.length)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  it 'has the correct schema' do
    expect(response).to match_json_schema("style/styles")
  end
end