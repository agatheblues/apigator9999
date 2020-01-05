require 'rails_helper'

describe "GET /styles gets all styles", :type => :request do
  context 'when authenticated' do
    let!(:styles) { 
      list = FactoryBot.create_list(:album, 10)
      styles = list.map { |album| album.styles}
      styles.flatten
    }
  
    before {get '/styles', headers: authenticated_header}

    it 'returns all styles' do
      expect(json['styles'].size).to eq(styles.length)
      expect(json['total_styles']).to eq(styles.length)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct schema' do
      expect(response).to match_json_schema("style/styles")
    end
  end

  context 'when unauthenticated' do
    before {get '/styles'}

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end