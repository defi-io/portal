Rails.application.routes.draw do
  get 'u', to: 'dex#uni'
  get 'j', to: 'dex#jup'
  get 'c', to: 'dex#cow'  
  get 'b', to: 'bridge#index'
  get 'url', to: 'home#url'

  # Defines the root path route ("/")
  root "home#index", as: 'home'
  mount Spina::Engine => '/feed'
  get '/:id' => "shortener/shortened_urls#show"
end
