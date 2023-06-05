module AccessDeniedHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      render json: { status: {code: 403, message: "You are not authorized to perform this action." }}, status: :forbidden
    end
  end
end