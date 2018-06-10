Rails.application.routes.draw do


  get 'sessions/sign_in'

  resources :products, only: [:index] do
    get "search", action: "search", on: :collection
  end

  root to: "home#index"

  post "login", to: "home#set_session"

end
