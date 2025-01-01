Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  namespace :admin do
    root to: 'dashboard#index'
    resources :users do
      collection do
        get :search
        get :admins
        get :regular_users
      end
      member do
        patch :toggle_admin
      end
    end
  end
  
  root "pages#home"

  # Static pages
  get 'privacy-policy', to: 'pages#privacy_policy', as: :privacy_policy
  get 'terms-of-service', to: 'pages#terms_of_service', as: :terms_of_service
  get 'sitemap', to: 'pages#sitemap', as: :sitemap
  get 'about', to: 'pages#about', as: :about
  get 'contact', to: 'pages#contact', as: :contact

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :capability_selection, only: [:new, :create], controller: 'capability_selection'
  resource :user, only: [:show, :update]

  resources :aircrafts
  
  resources :flights do
    member do
      patch :update_status
    end
    
    resources :bookings, shallow: true do
      member do
        patch :confirm
        patch :check_in
        patch :cancel
      end
    end
  end

  resources :bookings, only: [:index, :show]
end
