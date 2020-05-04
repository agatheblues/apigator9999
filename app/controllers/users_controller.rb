# frozen_string_literal: true

class UsersController < ApplicationController
  # Use Knock to make sure the current_user is authenticated before completing request.
  skip_before_action :authenticate_user, only: [:create]
  skip_before_action :verify_user_confirmed, only: [:create]
  before_action :set_user, only: %i[show update destroy]
  before_action :authorize_as_admin, only: %i[index update destroy]

  def index
    @users = User.all.order('created_at DESC')
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.zone.now)
    @current_user = current_user
  end

  def show; end

  def create
    User.create!(user_params)
    render json: { status: 201, message: 'User was created.' }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: 'error', code: 4000, message: e }, status: :bad_request
  end

  def update
    @user.update!(update_user_params)
    render :show, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: 'error', code: 4000, message: e }, status: :bad_request
  end

  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end

  def update_user_params
    params.permit(:confirmed_at)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
