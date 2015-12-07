Rails.application.routes.draw do
  get '/' => 'site#home'

  resources :travels, only: [:new, :show, :create, :destroy, :update]
  
end
