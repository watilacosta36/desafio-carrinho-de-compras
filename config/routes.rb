require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"

  namespace :api do
    namespace :v1 do
      resources :products
      resources :carts, only: %i[create]
    end
  end
end
