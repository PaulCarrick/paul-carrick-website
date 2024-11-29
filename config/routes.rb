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

      post 'validate_html', to: 'validations#validate_html'
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy"
  end

  namespace :admin do
    root "dashboard#index" # Admin dashboard
    resources :blogs, except: [ :destroy ]
    delete "/blogs/:id", to: "blogs#destroy", as: "delete_blog"
    get "/blogs/:id/delete", to: "blogs#destroy", as: "destroy_blog"
    resources :sections, except: [ :destroy ]
    delete "/sections/:id", to: "sections#destroy", as: "delete_section"
    get "/sections/:id/delete", to: "sections#destroy", as: "destroy_section"
  end

  resources :blog, only: [ :index ]
  resources :contact, only: [ :new, :create, :show ]
  resources :section, only: [ :index ]
  resources :search, only: [ :new ]

  get "professional", to: "pages#show", defaults: { id: "overview" }, as: :professional_page

  # Dynamic route for pages
  get "/:id", to: "pages#show", as: :page

  root "home#index"
end
