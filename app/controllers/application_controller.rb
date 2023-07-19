class ApplicationController < ActionController::API
  respond_to :jsonq
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_with_token
  attr_reader :current_user

  include AccessDeniedHandler
  include ExceptionHandler
  include PaginationControllerConcern
  include ResponseHandler

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def authenticate_user_with_token
    token = extract_token_from_headers(request.headers)
    if token
      decoded_token = JWT.decode(token, nil, false)
      payload = decoded_token.first['jti']
      payload = decoded_token.first

      if payload.key?('jti')
        jti = payload['jti'].to_s
        user = User.find_by(jti: jti)
        if user.nil?
          error_response('Unauthorized Access', nil, :unauthorized)
        elsif valid_token?(payload, user)
          @current_user = user
        else
          error_response('Unauthorized Access, incorrect token', nil, :unauthorized)
        end
      else
        error_response('Unauthorized Access or incorrect token', nil, :unauthorized)
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
