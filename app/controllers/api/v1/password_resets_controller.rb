class Api::V1::PasswordResetsController < ApplicationController
  skip_before_action :authenticate_user_with_token, only: [:create, :update]

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_reset_password_token
      # Send the password reset instructions email with the reset token link
      PasswordResetMailer.with(user: user).reset_instructions.deliver_now
      success_response('Reset password instructions sent successfully', nil, :ok)
    else
      error_response('Email address not found. Please check and try again.', nil, :not_found)
    end
  end

  def update
    user = User.find_by(reset_password_token: params[:token])
    if user && user.reset_password_token_valid?
      if user.reset_password(params[:password], params[:password_confirmation])
        success_response('Password reset successfully', nil, :ok)
      else
        error_response('Something went wrong', user.errors, :unprocessable_entity)
      end
    else
      error_response('Invalid or expired token', nil, :unprocessable_entity)
    end
  end

  private
end
