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

    render json: paginated_response[0].merge(data: serialized_collection)
  end
end
