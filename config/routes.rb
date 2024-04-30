Rails.application.routes.draw do
  get 'bridge/index'
  get 'dex/jup'
  get 'dex/cow'
  get 'dex/uni'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index", as: 'home'
end
