require 'rails_helper'

describe "GET /albums gets all albums", :type => :request do
  let(:filter_albums) { instance_double(FilterAlbums) }
  let(:albums) { FactoryBot.create_list(:album, 10) }
  let(:album_1) { albums.first }
  let(:album_2) { albums.second }
  let(:an_album_list) { Album.all }

  before { albums }

  context 'when authenticated' do
    context 'when no filters are applied' do
      subject(:request) { get '/albums', headers: authenticated_header }

      it 'returns :ok with correct schema' do
        expect_ok_schema({})
      end
    end

    context 'when a single genre filter is applied' do
      subject(:request) { get "/albums?genres=#{genre_id}", headers: authenticated_header }

      let(:genre_id) { album_1.genres.first.id }

      it 'returns :ok with correct schema' do
        expect_ok_schema({"genres" => genre_id.to_s })
      end
    end

    context 'when a single style filter is applied' do
      subject(:request) { get "/albums?styles=#{style_id}", headers: authenticated_header }

      let(:style_id) { album_1.styles.first.id }

      it 'returns :ok with correct schema' do
        expect_ok_schema({"styles" => style_id.to_s })
      end
    end

    context 'when many filters are applied' do
      subject(:request) { get "/albums?styles=#{style_1},#{style_2}&genres=#{genre_1},#{genre_2}", headers: authenticated_header }

      let(:style_1) { album_1.styles.first.id }
      let(:style_2) { album_2.styles.first.id }
      let(:genre_1) { album_1.genres.first.id }
      let(:genre_2) { album_2.genres.first.id }

      it 'returns :ok with correct schema' do
        expect_ok_schema({"styles" => "#{style_1},#{style_2}", "genres" => "#{genre_1},#{genre_2}"})
      end
    end
  end

  context 'when unauthenticated' do
    it 'get all albums returns unauthorized' do
      get '/albums'
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  def expect_ok_schema(params)
    expect(FilterAlbums).to receive(:new).with(Album.all, params)
      .and_return(filter_albums)
    expect(filter_albums).to receive(:call).and_return(an_album_list)
    request
    expect(response).to have_http_status(:ok)
    expect(response).to match_json_schema("album/albums")
  end
end

describe "GET /albums/:id gets the album", :type => :request do
  let(:album) { FactoryBot.create(:album) }
  let(:id) { album.id }

  before { album }

  context 'when authenticated' do
    context "with valid id" do
      before { get "/albums/#{id}", headers: authenticated_header }

      it 'returns the correct album' do
        expect(json['id']).to eq(id)
      end

      it 'returns :ok with correct schema' do
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema("album/album_extended")
      end
    end

    context "with invalid id" do
      before {get "/albums/-1", headers: authenticated_header}

      it 'returns 404 with correct schema' do
        expect(response).to have_http_status(:not_found)
        expect(response).to match_json_schema("error/error")
      end
    end
  end

  context 'when unauthenticated' do
    before { get "/albums/#{id}" }

    it 'get an album returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end