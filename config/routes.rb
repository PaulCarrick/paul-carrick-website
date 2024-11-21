# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :menu_items, only: %i[index show]
      resources :sections, only: %i[index show]
      resources :blog_posts
      resources :post_comments
    end
  end

  resources :bio, only: [ :index ]
  resources :blog, only: [ :index ]
  resources :contact, only: [ :new, :create ]
  resources :employment, only: [ :index ]
  resources :family, only: [ :index ]
  resources :hobby, only: [ :index ]
  resources :home, only: [ :index ]
  resources :live, only: [ :index ]
  resources :overview, only: [ :index ]
  resources :portfolio, only: [ :index ]
  resources :search, only: [ :index ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
