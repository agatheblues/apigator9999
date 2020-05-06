# frozen_string_literal: true

require 'rails_helper'

describe 'GET /batches/:id get the batch', type: :request do
  subject(:call) { get "/batches/#{id}", headers: headers }
  let(:batch) { FactoryBot.create(:batch) }
  let(:id) { batch.id }
  let(:headers) { admin_authenticated_header }

  context 'when authenticated as admin' do
    context 'with valid id' do
      it 'returns the correct batch' do
        expect(Sidekiq::Status).to receive(:status).with(batch.job_id).and_return('completed')
        call
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(
          {
            id: batch.id,
            status: 'completed'
          }.to_json
        )
      end
    end

    context 'with invalid id' do
      let(:id) { -1 }

      it 'returns 404 with correct schema' do
        call
        expect(response).to have_http_status(:not_found)
          .and match_json_schema('error/error')
      end
    end
  end

  context 'when authenticated but not admin' do
    let(:headers) { authenticated_header }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end

  context 'when unauthenticated' do
    let(:headers) { nil }

    it 'returns unauthorized' do
      call
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to be_empty
    end
  end
end
