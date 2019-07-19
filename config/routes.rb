# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

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
      get :reset
      post :send_confirmation_code
      get :confirm_reset
      post :change
    end
  end

  get :data_rules, to: 'upload#data_rules'
  get 'cookies', to: 'cookies#index'
  get 'health', to: 'application#health'
end
