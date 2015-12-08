Rails.application.routes.draw do
  get '/' => 'site#home'

  resources :travels, only: [:show, :create, :destroy, :update]

end
