# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get 'reset-password', to: 'registrations#reset_password'
    get 'update-password', to: 'registrations#update_password'
    get 'password-updated', to: 'registrations#password_updated'
  end

  root 'upload#index'

  resources :upload, only: %i[index] do
    collection do
      post :import
      get :processing
      get :success
    end
  end

  resources :passwords, only: %i[new create] do
    collection do
      get :success
    end
  end

  get :data_rules, to: 'upload#data_rules'
  get 'cookies', to: 'cookies#index'
  get '/health', to: 'application#health'
end
