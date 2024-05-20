Rails.application.routes.draw do
  get 'u', to: 'dex#uni'
  get 'j', to: 'dex#jup'
  get 'c', to: 'dex#cow'  
  get 'b', to: 'bridge#index'
  get 'url', to: 'home#url'
  get 'news', to: 'news#homepage'
  get 'ct', to: 'home#ct'
  get 'tb', to: 'home#tb'

  # Defines the root path route ("/")
  root "home#index", as: 'home'
  mount Spina::Engine => '/feed'
  get '/:id' => "shortener/shortened_urls#show"
end
