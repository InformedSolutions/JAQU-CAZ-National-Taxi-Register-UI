# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated(:user) { root 'upload#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  resources :vehicles, only: %i[index] do
    collection do
      get :search
      post :search, to: 'vehicles#submit_search'
      get :not_found
    end
  end

  resources :upload, only: %i[] do
    collection do
      post :import
      get :processing
      get :success
      get :data_rules
    end
  end

  resources :passwords, only: %i[new create] do
    collection do
      get '/', to: redirect('/')
      get :success
      get :reset
      post :send_confirmation_code
      get :confirm_reset
      post :change
    end
  end

  get :accessibility_statement, to: 'static_pages#accessibility_statement'
  get :cookies, to: 'static_pages#cookies'
  get :privacy_notice, to: 'static_pages#privacy_notice'

  get :health, to: 'application#health'
  get :build_id, to: 'application#build_id'

  match '/404', to: 'errors#not_found', via: :all
  # There is no 422 error page in design systems
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
