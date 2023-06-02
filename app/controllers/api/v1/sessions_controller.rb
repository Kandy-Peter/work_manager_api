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
          render json: {status: {message: 'Invalid email or password.'}}, status: :unauthorized
        end
      end

      def destroy
        puts "*****************"
        puts "*****************"
        puts "*****************"
        puts "*****************"
        secret_key_base = ENV['SECRET_KEY_BASE']
        token = request.headers['Authorization'].split('Bearer ').last

        puts "token*****************: #{token}"
        decoded_token = JWT.decode(token, secret_key_base, true, { algorithm: 'HS256' })
        payload = decoded_token.first
        
        if payload.key?('jti')
          jti = payload['jti'].to_s
          user = User.find_by(jti: jti)
          if user.nil?
            render json: { error: 'Invalid token for the user' }, status: :unauthorized
          elsif valid_token?(payload, user)
            user.jti = nil
            user.save
            render json: {status: {code: 200, message: 'Logged out successfully.'}}
          else
            render json: { error: 'Unauthorized Access' }, status: :unauthorized
          end
        else
          render json: { error: 'Unauthorized Access, incorrect token' }, status: :unauthorized
        end
      end
    
      private

      def sign_in_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
