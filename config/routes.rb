Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  devise_for :users, controllers: {sessions: "sessions"}

  authenticated :user do
    root 'menu#user_dashboard', as: :authenticated_root
  end

  devise_scope :user do
    root to: "sessions#new"
  end

  get 'chats', to: 'menu#user_dashboard'
  resources :chats, only: [:show, :create]
  resources :messages, only: [:create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
