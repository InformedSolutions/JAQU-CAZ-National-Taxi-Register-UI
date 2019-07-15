# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'upload#index'

  resources :upload, only: %i[index] do
    collection do
      post :import
    end
  end

  get :data_rules, to: 'upload#data_rules'
  get 'cookies', to: 'cookies#index'
  get '/health', to: 'application#health'
end
