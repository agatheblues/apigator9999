require 'rails_helper'

# describe "GET /albums gets all albums", :type => :request do
#   let!(:albums) { FactoryBot.create_list(:album, 10)}

#   before {get '/albums'}

#   it 'returns all albums' do
#     expect(json.size).to eq(10)
#   end

#   it 'returns status code 200' do
#     expect(response).to have_http_status(:success)
#   end

#   it 'has the correct schema' do
#     expect(response).to match_json_schema("album/albums")
#   end
# end

# describe "GET /artists/:id gets the artist", :type => :request do
#   let!(:id) { FactoryBot.create(:album).artists[0].id }
#   before {get "/artists/#{id}"}

#   it 'returns the correct artist' do
#     expect(json['id']).to eq(id)
#   end

#   it 'returns status code 200' do
#     expect(response).to have_http_status(:success)
#   end

#   it 'has the correct schema' do
#     expect(response).to match_json_schema("artist/artist")
#   end
# end