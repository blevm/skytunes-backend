Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get 'login', to: 'users#login'
      get 'sign-in', to: 'users#create'
      get 'current-user/:k', to: 'sessions#create'
      get 'user-check', to: 'users#checking'
      get 'search-zip/:username/:search', to: 'locations#zip_search'
      get 'search-city/:username/:search', to: 'locations#city_search'
      get 'search-intl/:username/:search', to: 'locations#intl_search'
      get ':username/search-current', to: 'locations#current_search'
      get ':username/:weather/recommended-tracks', to: 'users#get_recommended_tracks'
      get ':username/:weather/more-recommended-tracks', to: 'users#get_more_recommended_tracks'
      get ':username/seed-genres', to: 'users#get_seed_genres'
      post ':username/:title/new-playlist', to: 'users#new_playlist'
      get 'locations', to: 'locations#user_locations'
      get 'logout', to: 'users#logout'
    end
  end
end
