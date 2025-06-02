Rails.application.routes.draw do
  # Health check endpoint (outside locale scope)
  get "health", to: "healthy_check#status"

  # Redirect root to default locale
  root to: redirect("/en")

  # Redirect bare locale paths to admin
  get "/en", to: redirect("/en/admin")
  get "/ar", to: redirect("/ar/admin")

  # Routes with locale scope
  scope "/:locale", locale: /en|ar/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    mount GoodJob::Engine => "jobs"

    # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
    # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    namespace :admin do
    end

    namespace :trainer do
    end

    namespace :client do
    end
  end
end
