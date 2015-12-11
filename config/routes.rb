Rails.application.routes.draw do

  get '/' => 'site#home'

  post '/travels/:travel_id/join' => 'travels#join'
  post '/travels/:travel_id/left' => 'travels#left'

  devise_for :users, path: '',
                     path_names: {sign_in: 'login', sign_up: 'signup'},
                     controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}

  resources :users, only: [:show] do
    resources :travels, only: [:index, :show, :create, :destroy, :update]
    resources :travelers, only: [:index, :show, :create, :update, :destroy]
  end

  resources :travels, only: [:index] do
    resources :comments, only: [:index, :create, :destroy]
  end

end
