Rails.application.routes.draw do
  
  # ゲストログイン用
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root "events#index"

  resources :events, only: [:new, :create, :show]
end
