module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        user = User.find_by_email(sign_in_params[:email])
        if user&.valid_password?(sign_in_params[:password])
          token = user.generate_jwt_token
          response.headers['Authorization'] = "Bearer #{token}"
          render json: {status: {code: 200, message: 'Logged in successfully.'}, data: (UserSerializer.new(user).as_json), token: token}
        else
          render json: {status: {message: 'Invalid email or password.'}}, status: :unauthorized
        end
      end

      def destroy
        current_user&.authentication_token = nil
        if current_user&.save
          render json: {status: {code: 200, message: 'Logged out successfully.'}}
        else
          render json: {
            status: {message: "Something went wrong. #{resource.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
      end
    
      private

      def sign_in_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
