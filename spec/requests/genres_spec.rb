require "rails_helper"

RSpec.describe "Genres API", type: :request do
  # initialize test data
  let!(:genres) { create_list(:genre, 10) }
  let(:genre_id) { genres.first.id }

  describe "GET /genres" do
    before { get "/genres" }

    it "returns genres" do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "does not expand albums" do
      first_genre = json.first
      expect(first_genre).not_to be_nil
      expect(first_genre).not_to have_key("albums")
    end
  end

  describe "GET /genres/:id" do
    before { get "/genres/#{genre_id}" }

    context "when the record exists" do
      it "returns the genre" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(genre_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "expands albums list" do
        expect(json).to have_key("albums")
      end
    end

    context "when the record does not exist" do
      let(:genre_id) { 100 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Genre/)
      end
    end
  end

  describe "POST /genres" do
    # valid payload
    let(:valid_attributes) do
      {
        name: "genre_0",
        category: "style",
      }
    end

    # invalid payload
    let(:invalid_attributes) do
      valid_attributes.except(:name)
    end

    context "when the request is valid" do
      before { post "/genres", params: valid_attributes }

      it "creates an genre" do
        expect(json["name"]).to eq("genre_0")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/genres", params: {} }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end
    end

    context "when the request does not have a name" do
      before { post "/genres", params: invalid_attributes }

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a validation failure message" do
        expect(response.body).to match(
          /can't be blank/,
        )
      end
    end

    context "when the genre already exists" do
      before do
        post "/genres", params: valid_attributes
        post "/genres", params: valid_attributes
      end

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns a validation failure message" do
        expect(response.body).to match(
          /has already been taken/,
        )
      end
    end
  end

  describe "PATCH /genres/:id" do
    let(:valid_attributes) { { name: "updated_genre" } }

    context "when the record exists" do
      before { patch "/genres/#{genre_id}", params: valid_attributes }

      it "updates the record" do
        expect(response.body).to be_empty
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE /genres/:id" do
    before { delete "/genres/#{genre_id}" }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end
  end
end
