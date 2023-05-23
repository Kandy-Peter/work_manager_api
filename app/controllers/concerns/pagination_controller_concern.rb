module PaginationControllerConcern
  extend ActiveSupport::Concern

  included do
    include PaginationHelper
  end

  def render_paginated_response(collection, serializer: nil)
    paginated_response = paginate(collection)

    serialized_collection = if serializer.present?
      serializer.new(paginated_response[1])
    else
      paginated_response[1]
    end

    render json: {
      assistances: serialized_collection,  # Use serialized collection if a serializer is provided
      pagination: paginated_response[0][:pagination]
    }, status: :ok
  end
end
