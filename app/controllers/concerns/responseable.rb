module Responseable
  extend ActiveSupport::Concern

  included do
    if Rails.env.production? || Rails.env.test?
      rescue_from Exception do |e|
        logger.debug e.inspect
        raw_json_response({ status: "failure", message: e.message, data: [] }, 500)
      end
    end

    rescue_from StandardError do |e|
      e.backtrace.each { |line| logger.error(line) } if Rails.env.development?

      # Sentry.capture_exception(e) if Rails.env.production?

      raw_json_response({ status: "failure", message: e.message, data: [] }, :internal_server_error)
    end

    rescue_from CustomError do |e|
      raw_json_response({ status: "failure", message: e.message, data: [] }, e.code)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      logger.debug e.inspect
      raw_json_response({ status: "failure", message: "لم يتم العثور على المطلوب", data: [] }, :not_found)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      logger.debug e.inspect
      error_details = e.message.split("\n")[1]
      raw_json_response({ status: "failure", message: error_details, data: [] }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      logger.debug e.inspect
      raw_json_response({ status: "failure", message: e.message, data: e.record.errors.full_messages.to_sentence }, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      logger.debug e.inspect
      raw_json_response({ status: "failure", message: e.message, data: [ e ] }, :bad_request)
    end

    # rescue_from Pagy::OverflowError do |e|
    #   raw_json_response({ status: "failure", message: e.message, data: [e] }, :bad_request)
    # end

    rescue_from Date::Error do |e|
      raw_json_response({ status: "failure", message: e.message, data: [ e ] }, :bad_request)
    end

    # before_action :set_sentry_context
  end

  def raw_json_response(response, status = 200)
    render json: response, status: status
  end

  def json_response(data: [], message: "", code: 200)
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[code] if code.is_a?(Symbol)

    status = code.to_s.starts_with?("5", "4") ? "failure" : "success"

    raw_json_response({ status: status, message: message, data: data }, code)
  end

  # def set_sentry_context
  #   Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  # end
end
