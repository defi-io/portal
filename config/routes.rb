Rails.application.routes.draw do
  resources :coins
  resources :latest_prices
  get 'u', to: 'dex#uni'
  get 'j', to: 'dex#jup'
  get 'c', to: 'dex#cow'  
  get 'b', to: 'bridge#index'
  get 'url', to: 'home#url'
  get 'news', to: 'news#index'
  get 'n', to: 'news#index'
  get 'ct', to: 'news#ct'
  get 'tb', to: 'news#tb'
  get 'cd', to: 'news#cd'
  get 'dc', to: 'news#dc'
  get ':coin-to-usd', to: 'coins#to_usd'
  get ':coin-to-:currency', to: 'coins#to'
  get ':coin', to: 'coins#to_usd', constraints: { coin: /[a-zA-Z0-9]+/ }
  post 'convert', to: 'coins#convert'

  # Defines the root path route ("/")
  root "home#index", as: 'home'
  mount Spina::Engine => '/feed'
  get '/:id' => "shortener/shortened_urls#show"
end
