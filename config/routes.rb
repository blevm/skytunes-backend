Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'login', to: 'users#login'
      get 'current-user', to: 'users#create'
      get 'search-zip/:search', to: 'locations#zip_search'
      get 'search-city/:search', to: 'locations#city_search'
      get ':username/recommended-tracks', to: 'users#get_recommended_tracks'
    end
  end
end
