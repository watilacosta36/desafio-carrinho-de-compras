require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"

  namespace :api do
    namespace :v1 do
      resources :products
      resource :cart, only: %i[create show], controller: 'carts'

      post 'cart/add_item', to: 'carts#add_item'
      delete 'cart/:product_id', to: 'carts#remove_item'
    end
  end
end
