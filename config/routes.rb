Rails.application.routes.draw do
  get 'dex/jup'
  get 'dex/cow'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index", as: 'home'
end
