# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :menu_items, only: %i[index show]
      resources :footer_items, only: %i[index show]
      resources :pages, only: %i[index show]
      resources :sections, only: %i[index show]
      resources :blog_posts
      resources :post_comments
    end
  end

  devise_for :users

  namespace :admin do
    root "dashboard#index" # Admin dashboard
    # Add other admin routes here
  end

  resources :blog, only: [ :index ]
  resources :contact, only: [ :new, :create, :show ]
  resources :search, only: [ :index ]

  get "up" => "rails/health#show", as: :rails_health_check

  # Dynamic route for pages
  get "/:id", to: "pages#show", as: :page

  root "home#index"
end
