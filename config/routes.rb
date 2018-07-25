Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'login', to: 'users#login'
      get 'current-user', to: 'users#create'
      get 'search-zip/:search', to: 'locations#zip_search'
      get 'search-city/:search', to: 'locations#city_search'
      get 'search-intl/:search', to: 'locations#intl_search'
      get 'search-current', to: 'locations#current_search'
      get ':username/:weather/recommended-tracks', to: 'users#get_recommended_tracks'
      get ':username/seed-genres', to: 'users#get_seed_genres'
      post ':username/:title/new-playlist', to: 'users#new_playlist'
      get ':username/logout', to: 'users#logout'
    end
  end
end
