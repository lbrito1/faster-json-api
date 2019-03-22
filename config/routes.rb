Rails.application.routes.draw do
  namespace :api do
    resources :parties, only: [:index]
  end
end
