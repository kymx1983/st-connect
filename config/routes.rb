Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root "events#index"

  resources :events do
    resources :comments, only: %i[create destroy]
    member do
      post :join
      delete :unjoin
    end
  end

  resources :users, only: [:show]
  resources :relationships, only: %i[create destroy]
  resources :rooms, only: %i[create show update]
  resources :messages, only: %i[index create]
  resources :notifications, only: [:index]
end
