module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      skip_before_action :authenticate_user_with_token, only: [:create]

      def create
        user = User.new(sign_up_params)
        
        if user.save
          token = user.generate_jwt_token
          response.headers['Authorization'] = "Bearer #{token}"
          render json: {
            status: {code: 200, message: 'User created successfully.'},
            data: (UserSerializer.new(user).as_json),
            token: token
          }
        else
          error_response('Something went wrong', user.errors, :unprocessable_entity)
        end
      end

      private

      def sign_up_params
        params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :username)
      end
    end
  end
end
