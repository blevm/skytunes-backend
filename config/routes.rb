Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'login', to: 'users#login'
      get 'sign-in', to: 'users#create'
      get 'current-user/:k', to: 'sessions#create'
      get 'user-check', to: 'users#checking'
      get 'search-zip/:search', to: 'locations#zip_search'
      get 'search-city/:search', to: 'locations#city_search'
      get 'search-intl/:search', to: 'locations#intl_search'
      get 'search-current', to: 'locations#current_search'
      get ':weather/recommended-tracks', to: 'users#get_recommended_tracks'
      get ':weather/more-recommended-tracks', to: 'users#get_more_recommended_tracks'
      get 'seed-genres', to: 'users#get_seed_genres'
      post ':title/new-playlist', to: 'users#new_playlist'
      get 'locations', to: 'locations#user_locations'
      get 'logout', to: 'users#logout'
      delete 'locations/:id', to: 'locations#delete_user_locations'
    end
  end
end
