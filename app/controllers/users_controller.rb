# frozen_string_literal: true

class UsersController < ApplicationController
  # Use Knock to make sure the current_user is authenticated before completing request.
  skip_before_action :authenticate_user, only: [:create]
  before_action :authorize, only: %i[update destroy]
  before_action :set_user, only: %i[show update destroy]

  # Should work if the current_user is authenticated.
  def index
    render json: { status: 200, message: 'Logged-in' }
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    current_user.update!(last_login: Time.zone.now)
    @current_user = current_user
  end

  def show; end

  def create
    user = User.new(user_params)
    render json: { status: 201, message: 'User was created.' }, status: :created if user.save
  end

  def update
    @user.update!(user_params)
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

  def set_user
    @user = User.find(params[:id])
  end

  def authorize
    head :unauthorized unless current_user&.can_modify_user?(params[:id])
  end
end
