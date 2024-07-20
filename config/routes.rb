Rails.application.routes.draw do
  get 'calcalate', to: 'coins#calcalate'
  get 'search-coin', to: 'coins#search_coin'
  get 'search-currency', to: 'coins#search_currency'
  
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
  get ':from-to-:to', to: 'coins#to'
  get ':coin', to: 'coins#to_usd', constraints: { coin: /[a-zA-Z0-9]+/ }
  post 'convert', to: 'coins#convert'

  root "home#index", as: 'home'
  mount Spina::Engine => '/feed'
  get '/:id' => "shortener/shortened_urls#show"
end
