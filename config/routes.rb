Rails.application.routes.draw do

  get '/' => 'site#home'

  devise_for :users, path: '',
                     path_names: {sign_in: 'login', sign_up: 'signup'}

  resources :travels, only: [:show, :create, :destroy, :update]

end
