Rails.application.routes.draw do
  get '/login' , to: 'sessions#new'
  post '/login' , to: 'sessions#create'
  delete '/logout' , to: 'sessions#destroy'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get  '/patch',  to: 'users#patch'
  
  # get users/new, get users/1などのRESTフルセットを作成してくれる
  resources :users
end
