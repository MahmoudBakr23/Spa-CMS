class ApiController < ActionController::API
  include Responseable

  before_action :ensure_json_request
  before_action :set_response_metadata
  # before_action :render_filter_errors, unless: :filters_valid?

  protected

  def ensure_json_request
    request.format = :json
  end

  def set_response_metadata
    @response_metadata = {}
  end

  # def render_filter_errors
  #   render json: { errors: filter_errors }, status: :bad_request && return
  # end
end
