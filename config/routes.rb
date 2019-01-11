Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'chats', to: 'menu#user_dashboard'
  resources :chats, only: [:show, :create] do
    resources :messages, only [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
