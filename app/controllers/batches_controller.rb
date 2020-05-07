# frozen_string_literal: true

class BatchesController < ApplicationController
  before_action :authorize_as_admin, only: %i[create show]
  before_action :set_batch, only: %i[show]

  def create
    raise ActiveRecord::RecordInvalid unless params.key?('albums')

    batch = Batch.create!(data: params['albums'])
    job_id = CreateAlbumsWorker.perform_async(batch.id)
    batch.update(job_id: job_id)

    render json: { status: 'created', batch_id: batch.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: 'error', code: 4000, message: e.message }, status: :bad_request
  end

  def show
    status = Sidekiq::Status.status(@batch.job_id)
    render json: { id: @batch.id, status: status }, status: :ok
  end

  private

  def set_batch
    @batch = Batch.find(params[:id])
  end
end
