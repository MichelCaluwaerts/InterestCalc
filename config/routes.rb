Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get "my_accounts", to: "pages#my_accounts",  as: :account_list
  
  resources :accounts
  resources :rates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
