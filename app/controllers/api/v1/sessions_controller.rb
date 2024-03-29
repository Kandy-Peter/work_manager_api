module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_action :authenticate_user_with_token, only: [:create]

      def create
        user = User.find_by_email(sign_in_params[:email])
        if user&.valid_password?(sign_in_params[:password])
          token = user.generate_jwt_token
          response.headers['Authorization'] = "Bearer #{token}"
          render json: {status: {code: 200, message: 'Logged in successfully.'}, data: (UserSerializer.new(user).as_json), token: token}
        else
           error_response('Invalid email or password', nil, :unauthorized)
        end
      end

      def destroy
        current_user&.authentication_token = nil
        if current_user&.save
          success_response('Logged out successfully', nil, :ok)
        else
          error_response('Something went wrong', current_user&.errors, :unprocessable_entity)
        end
      end
    
      private

      def sign_in_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
