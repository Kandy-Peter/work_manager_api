class Api::V1::PasswordResetsController < ApplicationController
  skip_before_action :authenticate_user_with_token, only: [:create, :update]
  # load_and_authorize_resource :user

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_reset_password_token
      # Send the password reset instructions email with the reset token link
      PasswordResetMailer.with(user: user).reset_instructions.deliver_now
      render json: { message: 'Password reset instructions sent to your email' }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find_by(reset_password_token: params[:token])
    if user && user.reset_password_token_valid?
      if user.update_password(params[:password], params[:password_confirmation])
        render json: { message: 'Password reset successfully' }
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired token' }, status: :unprocessable_entity
    end
  end
end
