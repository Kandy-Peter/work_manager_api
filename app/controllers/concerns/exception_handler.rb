module ExceptionHandler

  extend ActiveSupport::Concern

  included do

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { 
        errors: [
          {
            title: 'Record not found',
            detail: e.message,
            code: '404'
          }
        ]
      }, status: 404
    end
   
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { 
        errors: [
          {
            title: 'Invalid record parameters',
            detail: e.message,
            code: '422'
          }
        ]
      }, status: 422
    end

  end
end
