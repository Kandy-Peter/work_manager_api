class PasswordResetMailer < ApplicationMailer
  def reset_instructions
    @user = params[:user]
    @reset_token = @user.reset_password_token
    # Adjust the URL to the frontend password reset form with the reset token
    @reset_url = "http://localhost:3000/password_resets/#{@reset_token}"
    
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

  def password_change(user)
    @user = user
    mail(to: @user.email, subject: 'Password Changed')
  end
end
