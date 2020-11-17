# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  authenticated(:user) { root 'upload#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  resources :vehicles, only: %i[index] do
    collection do
      get :search
      post :search, to: 'vehicles#submit_search'
      get :historic_search
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

  scope controller: 'static_pages' do
    get :accessibility_statement
    get :cookies
    get :privacy_notice
  end

  scope controller: 'application' do
    get :build_id
    get :health
  end

  scope controller: 'errors' do
    get :service_unavailable
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
