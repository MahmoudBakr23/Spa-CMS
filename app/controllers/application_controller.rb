class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def extract_locale
    # Priority: URL param > Session > Browser > Default
    requested_locale = params[:locale] || session[:locale] || extract_locale_from_accept_language_header
    requested_locale = requested_locale.to_s if requested_locale
    I18n.available_locales.map(&:to_s).include?(requested_locale) ? requested_locale.to_sym : nil
  end

  def extract_locale_from_accept_language_header
    return nil unless request.env["HTTP_ACCEPT_LANGUAGE"]

    accepted_languages = request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    case accepted_languages
    when "ar"
      :ar
    else
      :en
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  # Ensure locale is available in views
  def current_locale
    I18n.locale
  end
  helper_method :current_locale
end
