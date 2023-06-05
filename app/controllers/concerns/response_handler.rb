module ResponseHandler
  extend ActiveSupport::Concern

  def success_response(message = '', data = nil, status = :ok)
    render json: { status: { code: Rack::Utils.status_code(status), message: message }, data: data }, status: status
  end

  def error_response(message = '', data = nil, status = :unprocessable_entity)
    render json: { status: { code: Rack::Utils.status_code(status), message: message }, data: data }, status: status
  end
end
