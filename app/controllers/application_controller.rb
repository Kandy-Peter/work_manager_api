class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_with_token
  attr_reader :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def authenticate_user_with_token
    token = extract_token_from_headers(request.headers)
    if token.nil?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    else
      decoded_token = JWT.decode(token, nil, false)
      payload = decoded_token.first['jti']
      payload = decoded_token.first

      if payload.key?('jti')
        jti = payload['jti'].to_s
        user = User.find_by(jti: jti)
        if user.nil?
          render json: { error: 'Invalid token for the user' }, status: :unauthorized
        elsif valid_token?(payload, user)
          @current_user = user
        else
          render json: { error: 'Unauthorized Access' }, status: :unauthorized
        end
      else
        render json: { error: 'Unauthorized Access, incorrect token' }, status: :unauthorized
      end
    end
  end

  def extract_token_from_headers(headers)
    authorization_header = headers['Authorization']
    if authorization_header.present? && authorization_header.start_with?('Bearer ')
      token = authorization_header.split('Bearer ').last
      return token if token.present?
    end
    nil
  end
  
  def valid_token?(payload, user)
    expiration_datetime = Time.at(payload['exp'])
    expiration_datetime > Time.now && user.jti == payload['jti']
  end
end
