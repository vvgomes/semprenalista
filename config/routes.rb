Rails.application.routes.draw do
  match 'auth/:provider/callback',
    to: 'sessions#create',
    via: [:get, :post]

  match 'signout',
    to: 'sessions#destroy',
    as: 'signout',
    via: [:get, :post]

  resources :parties, :only => [:index, :show]

  root to: 'application#index'
end
