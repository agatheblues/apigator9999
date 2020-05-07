# frozen_string_literal: true

class BatchesController < ApplicationController
  before_action :authorize_as_admin, only: %i[create show]
  before_action :set_batch, only: %i[show]

  def create
    raise ActiveRecord::RecordInvalid unless albums_params.key?('albums')

    batch = Batch.create!(data: albums_params['albums'])
    job_id = CreateAlbumsWorker.perform_async(batch.id)
    Batch.update(batch.id, job_id: job_id)

    render json: { status: 'created', batch_id: batch.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: 'error', code: 4000, message: e.message }, status: :bad_request
  end

  def show
    status = Sidekiq::Status.status(@batch.job_id)
    render json: { id: @batch.id, status: status }, status: :ok
  end

  private

  def albums_params
    params.permit(albums: [:name, :release_date, :added_at, :total_tracks, :img_url, :img_width,
                           :img_height, :spotify_id, :discogs_id,
                           artists: %i[name img_url spotify_id discogs_id total_tracks total_albums],
                           genres: [:name],
                           styles: [:name]]).to_h
  end

  def set_batch
    @batch = Batch.find(params[:id])
  end
end
